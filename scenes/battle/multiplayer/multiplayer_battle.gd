extends Node
class_name MultiplayerBattle

const PORT = 4433
const ADDRESS = "127.0.0.1"

enum TURN_STATE {
	SELECTING_CHARACTER,
	SELECTING_COMMAND,
	SELECTING_TARGETS,
	RESOLVING_COMMANDS,
	WAITING_FOR_OPPONENT, # submitted, waiting on other player
	OTHER
}

# --- Serialized command exchanged over the network ---
# { "source_team": "my"/"opponent", "source_idx": int,
#   "command_name": String,
#   "target_indices": Array[int],   # indices into the *opposing* team
#   "speed_priority": int, "speed_bonus": int }

@export var _my_team_data: Array[CharacterData]
var _my_battle_team: Array[BattleCharacter]
var _opponent_team_data: Array[CharacterData]
var _opponent_battle_team: Array[BattleCharacter]

# Server only: tracks submitted command dicts keyed by peer id
var _pending_commands: Dictionary = {} # { peer_id: Array[Dictionary] }
var _expected_peers: Array[int] = [] # filled when battle starts on server

var _selected_character: BattleCharacter
var _selected_command: BattleCommand
var _ally_command_list: BattleCommandList = BattleCommandList.new()
var _combined_command_list: BattleCommandList = BattleCommandList.new()
var _target_provider: CommandTargetProvider

var _turn_state: TURN_STATE = TURN_STATE.OTHER:
	set(p_state):
		_turn_state = p_state
		if _command_status_label:
			_command_status_label.text = TURN_STATE.find_key(_turn_state)

@onready var _my_team_container = %AllyTeamContainer
@onready var _opponent_team_container = %EnemyTeamContainer
@onready var connect_menu = %ConnectMenu
@onready var battle_panel = %BattlePanel
@onready var _character_command_container: BattleCommandButtonContainer = %CommandContainer
@onready var _command_list_container: CommandListContainer = %CommandListContainer
@onready var _command_status_label: Label = %CommandStatusLabel

# -------------------------------------------------------------------------
# Connection setup
# -------------------------------------------------------------------------

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)

func create_server():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT)
	if error != OK:
		print("Failed to host: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Server started on port ", PORT)

func create_client():
	var peer = ENetMultiplayerPeer.new()
	var error = peer.create_client(ADDRESS, PORT)
	if error != OK:
		print("Failed to initialize client: ", error)
		return
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ADDRESS, "...")

func _on_peer_connected(id: int) -> void:
	print("Peer connected id:", id, " is_server:", multiplayer.is_server())
	_receive_team.rpc_id(id, _serialize_team(_my_team_data))

func _on_connected_to_server() -> void:
	print("Connected to server")

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected. ID: ", id)

func _on_connection_failed() -> void:
	print("Connection to server failed.")

# -------------------------------------------------------------------------
# Team exchange
# -------------------------------------------------------------------------

func _serialize_team(p_team: Array[CharacterData]) -> Array:
	var result: Array = []
	for character: CharacterData in p_team:
		result.append(character.to_dict())
	return result

@rpc("any_peer", "call_remote", "reliable")
func _receive_team(p_team: Array) -> void:
	_opponent_team_data.clear()
	for character_dict in p_team:
		_opponent_team_data.append(CharacterData.from_dict(character_dict))
	print("Opponent team received: ", _opponent_team_data.size(), " characters")
	_check_ready_to_start()

func _check_ready_to_start() -> void:
	if _my_team_data.is_empty() or _opponent_team_data.is_empty():
		return
	print("Both teams ready, starting battle!")
	start_battle()

func _convert_data_teams_to_battle_teams() -> void:
	_my_battle_team.clear()
	_opponent_battle_team.clear()
	for character_data: CharacterData in _my_team_data:
		_my_battle_team.append(BattleCharacter.new(character_data))
	for character_data: CharacterData in _opponent_team_data:
		_opponent_battle_team.append(BattleCharacter.new(character_data))

func _populate_team_ui() -> void:
	_my_team_container.battle_team = _my_battle_team
	_opponent_team_container.battle_team = _opponent_battle_team

func start_battle() -> void:
	_convert_data_teams_to_battle_teams()
	_populate_team_ui()
	_target_provider = CommandTargetProvider.new(_my_battle_team, _opponent_battle_team)
	_ally_command_list = BattleCommandList.new()
	_combined_command_list = BattleCommandList.new()
	_command_list_container.command_list = _ally_command_list

	# Server tracks who it expects commands from: itself (peer id 1) + all clients
	if multiplayer.is_server():
		_expected_peers.clear()
		_pending_commands.clear()
		_expected_peers.append(1) # server's own peer id
		for id in multiplayer.get_peers():
			_expected_peers.append(id)
		print("Server expecting commands from peers: ", _expected_peers)

	_turn_state = TURN_STATE.SELECTING_CHARACTER
	connect_menu.hide()
	battle_panel.show()

# -------------------------------------------------------------------------
# Local selection (same logic as singleplayer)
# -------------------------------------------------------------------------

func _on_battle_character_selected(p_selected_character: BattleCharacter) -> void:
	match _turn_state:
		TURN_STATE.SELECTING_CHARACTER, TURN_STATE.SELECTING_COMMAND:
			if p_selected_character in _opponent_battle_team:
				push_warning("Can't select enemies during command selection")
				return
			_selected_character = p_selected_character
			_character_command_container.battle_commands = _selected_character.battle_commands
			_turn_state = TURN_STATE.SELECTING_COMMAND

		TURN_STATE.SELECTING_TARGETS:
			var target_success: bool = _target_provider.add_target_to_command(
				_selected_command, p_selected_character
			)
			if target_success and _target_provider.has_maximum_targets(_selected_command):
				_ally_command_list.add_command(_selected_command)
				_selected_command = null
				_turn_state = TURN_STATE.SELECTING_CHARACTER

		_:
			push_error("Unexpected turn state in character selection")
			_turn_state = TURN_STATE.SELECTING_CHARACTER
			_character_command_container.battle_commands = []

func _on_command_selected(p_command: BattleCommand) -> void:
	_selected_command = p_command.duplicate_deep()
	_selected_command.source_character = p_command.source_character
	_turn_state = TURN_STATE.SELECTING_TARGETS
	_character_command_container.battle_commands = []

# -------------------------------------------------------------------------
# Submit: client serializes its command list and sends to server
# -------------------------------------------------------------------------

func _submit_commands() -> void:
	if not _ally_command_list.is_complete_and_valid(_my_battle_team):
		push_warning("Commands invalid, not submitting")
		return

	var serialized: Array = _serialize_command_list(_ally_command_list)
	_turn_state = TURN_STATE.WAITING_FOR_OPPONENT

	# Send to server (if we ARE the server, call locally so the dict is populated)
	if multiplayer.is_server():
		_server_receive_commands(1, serialized)
	else:
		_rpc_submit_commands.rpc_id(1, serialized)

# Commands are sent from any peer TO the server only
@rpc("any_peer", "call_remote", "reliable")
func _rpc_submit_commands(p_commands: Array) -> void:
	if not multiplayer.is_server():
		push_warning("Non-server received submit_commands RPC — ignoring")
		return
	var sender_id: int = multiplayer.get_remote_sender_id()
	_server_receive_commands(sender_id, p_commands)

func _server_receive_commands(p_peer_id: int, p_commands: Array) -> void:
	print("Server received commands from peer ", p_peer_id)
	_pending_commands[p_peer_id] = p_commands

	# Check if all expected peers have submitted
	for expected_id in _expected_peers:
		if not _pending_commands.has(expected_id):
			print("Still waiting on peer ", expected_id)
			return

	print("All commands received — resolving!")
	_server_resolve_and_broadcast()

# -------------------------------------------------------------------------
# Server: resolve and broadcast results
# -------------------------------------------------------------------------

func _server_resolve_and_broadcast() -> void:
	# Build a flat result list: Array of { "source_peer": int, "source_idx": int,
	#   "command_name": String, "target_results": Array[{ "target_peer": int,
	#   "target_idx": int, "hp_delta": int, "new_hp": int }] }
	#
	# The server owns ground-truth BattleCharacter state for both sides.
	# To do this cleanly we reconstruct both teams from the pending command data
	# so resolution is deterministic.
	#
	# NOTE: Because both peers start from the same CharacterData and we only
	# send hp_deltas, clients can apply results to their local BattleCharacters.
	var result_log: Array = []

	# Collect all commands into one combined list, resolve speed order
	var combined: BattleCommandList = BattleCommandList.new()

	for peer_id in _pending_commands:
		var cmd_array: Array = _pending_commands[peer_id]
		for cmd_dict in cmd_array:
			var battle_cmd: BattleCommand = _deserialize_command(cmd_dict, peer_id)
			if battle_cmd:
				combined.add_command(battle_cmd)

	# Execute in speed order and record hp deltas
	for battle_cmd: BattleCommand in combined.commands_view:
		var cmd_result: Dictionary = _execute_and_record(battle_cmd)
		result_log.append(cmd_result)

	# Broadcast results to all peers (including self via local call)
	var result_log_typed: Array = result_log # plain Array is RPC-safe
	_rpc_receive_results.rpc(result_log_typed)
	# Also apply on the server itself
	_apply_results(result_log_typed)

	_pending_commands.clear()

func _execute_and_record(p_cmd: BattleCommand) -> Dictionary:
	# Before execution snapshot target HP, then execute, then diff
	var pre_hp: Array = []
	for target: BattleCharacter in p_cmd.targets:
		pre_hp.append(target.character_resources[Stats.RESOURCE_NAMES.HEALTH].current_value)

	p_cmd.execute()

	var target_results: Array = []
	for i in p_cmd.targets.size():
		var target: BattleCharacter = p_cmd.targets[i]
		var new_hp: int = target.character_resources[Stats.RESOURCE_NAMES.HEALTH].current_value
		var delta: int = new_hp - pre_hp[i]
		# Identify target by which team + index (server knows both teams)
		var team_key: String = "my" if target in _my_battle_team else "opponent"
		var idx: int = (_my_battle_team if team_key == "my" else _opponent_battle_team).find(target)
		target_results.append({
			"team": team_key,
			"idx": idx,
			"hp_delta": delta,
			"new_hp": new_hp,
		})

	var source_team: String = "my" if p_cmd.source_character in _my_battle_team else "opponent"
	var source_idx: int = (_my_battle_team if source_team == "my" \
		else _opponent_battle_team).find(p_cmd.source_character)

	return {
		"command_name": p_cmd.command_name,
		"source_team": source_team,
		"source_idx": source_idx,
		"target_results": target_results,
	}

# -------------------------------------------------------------------------
# Client: receive and apply results
# -------------------------------------------------------------------------

@rpc("authority", "call_remote", "reliable")
func _rpc_receive_results(p_result_log: Array) -> void:
	_apply_results(p_result_log)

func _apply_results(p_result_log: Array) -> void:
	# Apply hp deltas to local BattleCharacter instances
	# "my" team = _my_battle_team, "opponent" = _opponent_battle_team
	for entry in p_result_log:
		var target_results: Array = entry["target_results"]
		for target_result in target_results:
			var team: Array[BattleCharacter] = \
				_my_battle_team if target_result["team"] == "my" else _opponent_battle_team
			if target_result["idx"] < team.size():
				var target: BattleCharacter = team[target_result["idx"]]
				target.character_resources[Stats.RESOURCE_NAMES.HEALTH].current_value = target_result["new_hp"]
				print("Applied result: %s[%d] HP -> %d (delta %d)" % [
					target_result["team"], target_result["idx"], target_result["new_hp"], target_result["hp_delta"]
				])

	_ally_command_list.clear()
	_combined_command_list.clear()
	_turn_state = TURN_STATE.SELECTING_CHARACTER
	_check_battle_end()

# -------------------------------------------------------------------------
# Serialization helpers
# -------------------------------------------------------------------------

func _serialize_command_list(p_list: BattleCommandList) -> Array:
	var result: Array = []
	for cmd: BattleCommand in p_list.commands_view:
		result.append(_serialize_command(cmd))
	return result

func _serialize_command(p_cmd: BattleCommand) -> Dictionary:
	# Targets are always from the *opponent* team (for now — extend for SELF/ALLY later)
	var target_indices: Array[int] = []
	for target: BattleCharacter in p_cmd.targets:
		target_indices.append(_opponent_battle_team.find(target))

	var source_idx: int = _my_battle_team.find(p_cmd.source_character)

	return {
		"command_name": p_cmd.command_name,
		"source_idx": source_idx,
		"target_indices": target_indices,
		"speed_priority": p_cmd.speed_priority,
		"speed_bonus": p_cmd.speed_bonus,
	}

func _deserialize_command(p_dict: Dictionary, p_sender_peer_id: int) -> BattleCommand:
	var cmd_template: BattleCommand = CommandRegistryAutoload.find_command_by_name(
		p_dict["command_name"]
	)
	if not cmd_template:
		push_error("Unknown command during deserialization: ", p_dict["command_name"])
		return null

	var cmd: BattleCommand = cmd_template.duplicate_deep()

	# Determine which team is "my" vs "opponent" FROM THE SERVER'S PERSPECTIVE.
	# The server's own peer id is 1; client peers have higher ids.
	# We need to map sender's "my team" → the correct server-side Array.
	# Convention: server's _my_battle_team = the team the server controls.
	var sender_team: Array[BattleCharacter]
	var sender_target_team: Array[BattleCharacter]
	if p_sender_peer_id == 1:
		# Server's own commands
		sender_team = _my_battle_team
		sender_target_team = _opponent_battle_team
	else:
		# Client's commands — their "my team" is our opponent team
		sender_team = _opponent_battle_team
		sender_target_team = _my_battle_team

	var source_idx: int = p_dict["source_idx"]
	if source_idx < 0 or source_idx >= sender_team.size():
		push_error("Invalid source_idx ", source_idx)
		return null

	cmd.source_character = sender_team[source_idx]

	for target_idx in p_dict["target_indices"]:
		if target_idx >= 0 and target_idx < sender_target_team.size():
			cmd.targets.append(sender_target_team[target_idx])
		else:
			push_error("Invalid target_idx ", target_idx)

	return cmd

# -------------------------------------------------------------------------
# Battle end
# -------------------------------------------------------------------------

func _check_battle_end() -> void:
	if _is_team_dead(_my_battle_team) or _is_team_dead(_opponent_battle_team):
		_end_battle()

func _is_team_dead(p_team: Array[BattleCharacter]) -> bool:
	for battle_character in p_team:
		if not battle_character.is_dead():
			return false
	return true

func _end_battle() -> void:
	print("Battle ended")
	_turn_state = TURN_STATE.OTHER
	# TODO: show result screen, return to lobby, etc.
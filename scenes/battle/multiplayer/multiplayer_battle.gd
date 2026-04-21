extends Node
class_name MultiplayerBattle

const PORT = 4433
const ADDRESS = "127.0.0.1"

enum TURN_STATE {
	SELECTING_CHARACTER,
	SELECTING_COMMAND,
	SELECTING_TARGETS,
	RESOLVING_COMMANDS,
	OTHER
}

@export var _my_team_data: Array[CharacterData]
var _my_battle_team: Array[BattleCharacter]

var _opponent_team_data: Array[CharacterData]
var _opponent_battle_team: Array[BattleCharacter]

@onready var _my_team_container = %AllyTeamContainer
@onready var _oppponent_team_container = %EnemyTeamContainer
@onready var connect_menu = %ConnectMenu
@onready var battle_panel = %BattlePanel
@onready var _character_command_container: BattleCommandButtonContainer = %CommandContainer
@onready var _command_list_container: CommandListContainer = %CommandListContainer
@onready var _command_status_label: Label = %CommandStatusLabel

var _selected_character: BattleCharacter
var _selected_command: BattleCommand
var _ally_command_list: BattleCommandList = BattleCommandList.new()
var _enemy_command_list: BattleCommandList = BattleCommandList.new()
var _combined_command_list: BattleCommandList = BattleCommandList.new()
var _target_provider: CommandTargetProvider
var _turn_state: TURN_STATE = TURN_STATE.OTHER:
	set(p_state):
		_turn_state = p_state
		if _command_status_label:
			_command_status_label.text = TURN_STATE.find_key(_turn_state)


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
	print("_on_peer_connected fired, is_server: ", multiplayer.is_server(), " id: ", id)
	# Both peers send their own team to the other when connection is established
	_receive_team.rpc_id(id, _serialize_team(_my_team_data))

func _on_connected_to_server() -> void:
	# Client also sends their team to the server on connect
	# (server's _on_peer_connected fires for the client, but client
	#  needs to separately push to server using server's known id of 1)
	# _receive_team.rpc_id(1, _serialize_team(_my_team_data))
	print("_on_connected_to_server fired, is_server: ", multiplayer.is_server())

func _on_peer_disconnected(id: int) -> void:
	print("Peer disconnected. ID: ", id)

func _on_connection_failed() -> void:
	print("Connection to server failed.")

func _serialize_team(p_team: Array[CharacterData]) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
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
	for character_data: CharacterData in _my_team_data:
		_my_battle_team.append(BattleCharacter.new(character_data))
	for character_data: CharacterData in _opponent_team_data:
		_opponent_battle_team.append(BattleCharacter.new(character_data))

func _populate_team_ui() -> void:
	_my_team_container.battle_team = _my_battle_team
	_oppponent_team_container.battle_team = _opponent_battle_team

func start_battle() -> void:
	_convert_data_teams_to_battle_teams()
	_populate_team_ui()
	_command_list_container.command_list = _ally_command_list
	_target_provider = CommandTargetProvider.new(_my_battle_team, _opponent_battle_team)
	_turn_state = TURN_STATE.SELECTING_CHARACTER
	connect_menu.hide()
	battle_panel.show()

func _on_battle_character_selected(p_selected_character: BattleCharacter) -> void:
	match _turn_state:
		TURN_STATE.SELECTING_CHARACTER, TURN_STATE.SELECTING_COMMAND:
			if p_selected_character in _opponent_battle_team:
				push_warning("Can't select enemies")
				return
			_selected_character = p_selected_character
			_character_command_container.battle_commands = _selected_character.battle_commands
			_turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_TARGETS:
			# Attempt to add a target to current command
			# Check if this is the last target then lock in the command
			var target_success: bool = _target_provider.add_target_to_command(_selected_command, p_selected_character)
			if target_success and _target_provider.has_maximum_targets(_selected_command):
				print("max targets reached")
				_ally_command_list.add_command(_selected_command)
				_selected_command = null
				_turn_state = TURN_STATE.SELECTING_CHARACTER
		_:
			push_error("Hit turn state fallback. Attempting reset")
			_turn_state = TURN_STATE.SELECTING_CHARACTER
			_character_command_container.clear()

func _on_command_selected(p_command: BattleCommand) -> void:
	_selected_command = p_command.duplicate_deep()
	_selected_command.source_character = p_command.source_character
	_turn_state = TURN_STATE.SELECTING_TARGETS
	_character_command_container.battle_commands = []

func _submit_commands() -> void:
	if not _ally_command_list.is_complete_and_valid(_my_battle_team):
		push_warning("Commands invalid, did not resolve")
		return
	print("valid commands, send over network here")

# Make sure to rework this to make it server authoritative
func _resolve_commands() -> void:
	_turn_state = TURN_STATE.RESOLVING_COMMANDS
	# Add commands from allies and enemies one by one for validation
	# Can combine lists because speed will be re-evaluated on the combined list
	# TODO: Refactor initial lists? Feels not performant
	for command in _ally_command_list.commands_view + _enemy_command_list.commands_view:
		_combined_command_list.add_command(command)
	for command: BattleCommand in _combined_command_list.commands_view:
		command.execute()
	_ally_command_list.clear()
	_enemy_command_list.clear()
	_combined_command_list.clear()
	_turn_state = TURN_STATE.SELECTING_CHARACTER
	_check_battle_end()

func _check_battle_end() -> void:
	if _is_team_dead(_my_battle_team) or _is_team_dead(_opponent_battle_team):
		_end_battle()

func _is_team_dead(p_team: Array[BattleCharacter]) -> bool:
	for battle_character in p_team:
		if not battle_character.is_dead():
			return false
	return true

func _end_battle() -> void:
	print("ending battle")
	# _selected_character = null
	# _selected_command = null
	# _ally_battle_team = []
	# _enemy_battle_team = []
	# _ally_command_list.clear()
	# _target_provider = null
	# _enemy_target_provider = null
	# _turn_state = TURN_STATE.OTHER
	# exit_battle_requested.emit()

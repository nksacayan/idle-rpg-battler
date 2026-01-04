extends Node

signal turn_state_changed(p_state: TURN_STATE)
signal _player_commands_received

enum TURN_STATE {
	SELECTING_CHARACTER,
	SELECTING_COMMAND,
	SELECTING_TARGET,
	OTHER
}

@export var ally_team: Array[CharacterData]
@export var enemy_team: Array[CharacterData]
var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]
var command_list: BattleCommandList
var selected_character: BattleCharacter
var _turn_state: TURN_STATE = TURN_STATE.OTHER
var turn_state: TURN_STATE = TURN_STATE.OTHER:
	get:
		return _turn_state
	set(p_state):
		_turn_state = p_state
		turn_state_changed.emit(_turn_state)
# get player commands for each character
# execute commands
# enemy turn (we'll mess with turn order later)
@onready var _ally_team_container: BattleTeamContainer = %AllyTeamContainer
@onready var _enemy_team_container: BattleTeamContainer = %EnemyTeamContainer
@onready var _command_container: BattleCommandContainer = %CommandContainer

func _ready() -> void:
	_setup_battle_characters()
	_setup_battle_team_containers()
	_setup_command_container()
	_run_main_battle_loop()

func _setup_battle_team_containers() -> void:
	_ally_team_container.setup(ally_battle_team)
	_ally_team_container.character_selected.connect(_on_battle_character_selected)
	_enemy_team_container.setup(enemy_battle_team)
	_enemy_team_container.character_selected.connect(_on_battle_character_selected)

func _setup_battle_characters() -> void:
	ally_battle_team = _convert_data_to_battle_chars(ally_team)
	enemy_battle_team = _convert_data_to_battle_chars(enemy_team)

func _convert_data_to_battle_chars(data_array: Array[CharacterData]) -> Array[BattleCharacter]:
	var result: Array[BattleCharacter] = []
	for data in data_array:
		result.append(BattleCharacter.new(data))
	return result

func _setup_command_container() -> void:
	_command_container.command_selected.connect(_on_command_selected)

func _run_main_battle_loop() -> void:
	while not _is_battle_over():
		print("running battle loop")
		var player_commands_awaited := await _get_player_commands()
		if player_commands_awaited:
			print("true player command")
		else:
			print("false player commands")

func _get_player_commands() -> bool:
	turn_state = TURN_STATE.SELECTING_CHARACTER
	await _player_commands_received
	return true

func _resolve_commands() -> bool:
	print("_resolve_commands")
	for command: BattleCommand in command_list.commands_view:
		command.execute()
	command_list.clear()
	return true

func _run_enemy_turn() -> bool:
	print("_run_enemy_turn")
	return true

func _is_battle_over() -> bool:
	return false

func emit_player_commands_recieved() -> void:
	_player_commands_received.emit()

func _on_battle_character_selected(p_battle_character: BattleCharacter) -> void:
	selected_character = p_battle_character
	_command_container.setup(selected_character.character_data.battle_commands)

func _on_command_selected(p_command: BattleCommand) -> void:
	# wire in targeter here?
	command_list.add_command(p_command)

func _on_submit_commands() -> void:
	print("submit commands")
	var all_battle_characters: Array[BattleCharacter]
	all_battle_characters.append_array(ally_battle_team)
	all_battle_characters.append_array(enemy_battle_team)
	if command_list.is_complete_and_valid(all_battle_characters):
		_player_commands_received.emit()

func _on_submit_commands_button_pressed() -> void:
	_on_submit_commands()

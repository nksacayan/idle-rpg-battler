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
var command_list: BattleCommandList = BattleCommandList.new()
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
	turn_state = TURN_STATE.SELECTING_CHARACTER

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
	match turn_state:
		TURN_STATE.SELECTING_CHARACTER:
			_command_container.setup(p_battle_character.character_data.battle_commands)
			turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_COMMAND:
			# This means we want to change characters rather than select a command
			_command_container.setup(p_battle_character.character_data.battle_commands)
			turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_TARGET:
			# Attempt to add a target to current command
			# Check if this is the last target then lock in the command
			# Let players try to submit attacks whenever, but maybe do a UI thing to show that the character has a command submitted?
			turn_state = TURN_STATE.SELECTING_CHARACTER
			_command_container.clear()
		_:
			push_error("Hit turn state fallback. Attempting reset")
			turn_state = TURN_STATE.SELECTING_CHARACTER
			_command_container.clear()
			pass

func _on_command_selected(p_command: BattleCommand) -> void:
	# wire in targeter here?
	command_list.add_command(p_command)

func _submit_commands() -> void:
	print("submit commands")
	var all_battle_characters: Array[BattleCharacter]
	all_battle_characters.append_array(ally_battle_team)
	all_battle_characters.append_array(enemy_battle_team)
	if command_list.is_complete_and_valid(all_battle_characters):
		_player_commands_received.emit()

func _on_submit_commands_button_pressed() -> void:
	_submit_commands()

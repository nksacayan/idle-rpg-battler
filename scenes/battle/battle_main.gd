extends Node
class_name BattleMain

signal turn_state_changed(p_state: TURN_STATE)
signal exit_battle_requested

enum TURN_STATE {
	SELECTING_CHARACTER,
	SELECTING_COMMAND,
	SELECTING_TARGETS,
	RESOLVING_COMMANDS,
	OTHER
}

var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]
var _current_character: BattleCharacter
var _current_command: BattleCommand
var command_list: BattleCommandList = BattleCommandList.new()
var target_provider: CommandTargetProvider
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
# References: Use @onready as a fallback, but we will refresh them
@onready var _ally_team_container: BattleTeamContainer = %AllyTeamContainer
@onready var _enemy_team_container: BattleTeamContainer = %EnemyTeamContainer
@onready var _character_command_container: BattleCommandButtonContainer = %CommandContainer
@onready var _command_list_container: CommandListContainer = %CommandListContainer

# 1. Lifecycle Agnostic Refresh
func _enter_tree() -> void:
	# Forces _ready() to run again when the node re-enters the tree
	request_ready()

func _ready() -> void:
	# Re-validate references in case the UI tree changed while we were cached
	_refresh_ui_references()

	# Initialization logic that must run every time battle "starts"
	_setup_battle_team_containers()
	_command_list_container.command_list = command_list # WIP
	target_provider = CommandTargetProvider.new(ally_battle_team, enemy_battle_team)
	turn_state = TURN_STATE.SELECTING_CHARACTER

func _refresh_ui_references() -> void:
	# Safely re-grab %UniqueID nodes to avoid "Null Instance" errors 
	# if the node structure changed during the cache period
	_ally_team_container = %AllyTeamContainer
	_enemy_team_container = %EnemyTeamContainer
	_character_command_container = %CommandContainer

	# 2. Data Persistence (Setup should be call-able outside tree)
func setup(p_ally_team: Array[BattleCharacter], p_enemy_team: Array[BattleCharacter]) -> void:
	ally_battle_team = p_ally_team
	enemy_battle_team = p_enemy_team
	# If already in tree, refresh immediately; if not, _ready() handles it later
	if is_inside_tree():
		_setup_battle_team_containers()

func _setup_battle_team_containers() -> void:
	# Use the setter logic we discussed previously for clean UI updates
	_ally_team_container.battle_team = ally_battle_team
	_enemy_team_container.battle_team = enemy_battle_team


func _is_battle_over() -> bool:
	return false

func _on_battle_character_selected(p_battle_character: BattleCharacter) -> void:
	match turn_state:
		TURN_STATE.SELECTING_CHARACTER, TURN_STATE.SELECTING_COMMAND:
			if p_battle_character in enemy_battle_team:
				push_warning("Can't select enemy characters for commands")
				return
			_current_character = p_battle_character
			_current_character.current_command_ref = null
			_character_command_container.battle_commands = _current_character.local_battle_commands
			turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_TARGETS:
			# Attempt to add a target to current command
			# Check if this is the last target then lock in the command
			var target_success: bool = target_provider.add_target_to_command(_current_command, p_battle_character)
			if target_success and target_provider.has_maximum_targets(_current_command):
				print("max targets reached")
				_current_character.current_command_ref = _current_command
				command_list.add_command(_current_command)
				_current_command = null
				turn_state = TURN_STATE.SELECTING_CHARACTER
		_:
			push_error("Hit turn state fallback. Attempting reset")
			turn_state = TURN_STATE.SELECTING_CHARACTER
			_character_command_container.clear()
			pass

func _on_command_selected(p_command: BattleCommand) -> void:
	_current_command = p_command.duplicate_deep()
	_current_command.source_character = p_command.source_character
	turn_state = TURN_STATE.SELECTING_TARGETS
	_character_command_container.battle_commands = []

func _submit_commands() -> void:
	print("submit commands")
	if command_list.is_complete_and_valid(ally_battle_team + enemy_battle_team):
		_resolve_commands()
	else:
		push_warning("Commands invalid, did not resolve")

func _resolve_commands() -> void:
	turn_state = TURN_STATE.RESOLVING_COMMANDS
	print("_resolve_commands: ", command_list.commands_view)
	for command: BattleCommand in command_list.commands_view:
		print("resolving command: ", command.command_name, " source: ", command.source_character, " targets: ", command.targets)
		command.execute()
	command_list.clear()
	turn_state = TURN_STATE.SELECTING_CHARACTER

func _clear_character_command_refs() -> void:
	for character: BattleCharacter in ally_battle_team + enemy_battle_team:
		character.current_command_ref = null

func _exit_battle() -> void:
	exit_battle_requested.emit()

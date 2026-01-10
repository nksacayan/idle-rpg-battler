extends Node
class_name BattleMain

signal turn_state_changed(p_state: TURN_STATE)

enum TURN_STATE {
	SELECTING_CHARACTER,
	SELECTING_COMMAND,
	SELECTING_TARGETS,
	RESOLVING_COMMANDS,
	OTHER
}

var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]
var current_character: BattleCharacter
var current_command: BattleCommand
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
@onready var _ally_team_container: BattleTeamContainer = %AllyTeamContainer
@onready var _enemy_team_container: BattleTeamContainer = %EnemyTeamContainer
@onready var _command_container: BattleCommandContainer = %CommandContainer

func setup(p_ally_team: Array[BattleCharacter], p_enemy_team: Array[BattleCharacter]) -> void:
	ally_battle_team = p_ally_team
	enemy_battle_team = p_enemy_team

func _ready() -> void:
	_setup_battle_team_containers()
	target_provider = CommandTargetProvider.new(ally_battle_team, enemy_battle_team)
	turn_state = TURN_STATE.SELECTING_CHARACTER

func _setup_battle_team_containers() -> void:
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
			current_character = p_battle_character
			current_character.current_command_ref = null
			_command_container.setup(p_battle_character.local_battle_commands)
			turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_TARGETS:
			# Attempt to add a target to current command
			# Check if this is the last target then lock in the command
			var target_success: bool = target_provider.add_target_to_command(current_command, p_battle_character)
			if target_success and target_provider.has_maximum_targets(current_command):
				print("max targets reached")
				current_character.current_command_ref = current_command
				command_list.add_command(current_command)
				current_command = null
				turn_state = TURN_STATE.SELECTING_CHARACTER
		_:
			push_error("Hit turn state fallback. Attempting reset")
			turn_state = TURN_STATE.SELECTING_CHARACTER
			_command_container.clear()
			pass

func _on_command_selected(p_command: BattleCommand) -> void:
	current_command = p_command
	turn_state = TURN_STATE.SELECTING_TARGETS
	_command_container.clear()

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

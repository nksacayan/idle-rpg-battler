extends Node
class_name BattleMain

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
var _ally_command_list: BattleCommandList = BattleCommandList.new()
var _enemy_command_list: BattleCommandList = BattleCommandList.new()
var _target_provider: CommandTargetProvider
var _turn_state: TURN_STATE = TURN_STATE.OTHER:
	set(p_state):
		_turn_state = p_state
		if _command_status_label:
			_command_status_label.text = TURN_STATE.find_key(_turn_state)

# enemy turn (we'll mess with turn order later)
@onready var _ally_team_container: BattleTeamContainer = %AllyTeamContainer
@onready var _enemy_team_container: BattleTeamContainer = %EnemyTeamContainer
@onready var _character_command_container: BattleCommandButtonContainer = %CommandContainer
@onready var _command_list_container: CommandListContainer = %CommandListContainer
@onready var _command_status_label: Label = %CommandStatusLabel

func _ready() -> void:
	_setup_battle_team_containers()
	_command_list_container.command_list = _ally_command_list
	_target_provider = CommandTargetProvider.new(ally_battle_team, enemy_battle_team)
	_turn_state = TURN_STATE.SELECTING_CHARACTER

func setup(p_ally_team: Array[BattleCharacter], p_enemy_team: Array[BattleCharacter]) -> void:
	if is_node_ready():
		push_error("Tried to setup battle_main while it's already ready")
		return
	ally_battle_team = p_ally_team
	enemy_battle_team = p_enemy_team

func _setup_battle_team_containers() -> void:
	_ally_team_container.battle_team = ally_battle_team
	_enemy_team_container.battle_team = enemy_battle_team

func _on_battle_character_selected(p_battle_character: BattleCharacter) -> void:
	match _turn_state:
		TURN_STATE.SELECTING_CHARACTER, TURN_STATE.SELECTING_COMMAND:
			if p_battle_character in enemy_battle_team:
				push_warning("Can't select enemy characters for commands")
				return
			_current_character = p_battle_character
			_character_command_container.battle_commands = _current_character.battle_commands
			_turn_state = TURN_STATE.SELECTING_COMMAND
		TURN_STATE.SELECTING_TARGETS:
			# Attempt to add a target to current command
			# Check if this is the last target then lock in the command
			var target_success: bool = _target_provider.add_target_to_command(_current_command, p_battle_character)
			if target_success and _target_provider.has_maximum_targets(_current_command):
				print("max targets reached")
				_ally_command_list.add_command(_current_command)
				_current_command = null
				_turn_state = TURN_STATE.SELECTING_CHARACTER
		_:
			push_error("Hit turn state fallback. Attempting reset")
			_turn_state = TURN_STATE.SELECTING_CHARACTER
			_character_command_container.clear()

func _on_command_selected(p_command: BattleCommand) -> void:
	_current_command = p_command.duplicate_deep()
	_current_command.source_character = p_command.source_character
	_turn_state = TURN_STATE.SELECTING_TARGETS
	_character_command_container.battle_commands = []

func _submit_commands() -> void:
	if not _ally_command_list.is_complete_and_valid(ally_battle_team):
		push_warning("Commands invalid, did not resolve")
		return
	
	_randomly_pick_enemy_commands()
	_resolve_commands()

func _randomly_pick_enemy_commands() -> void:
	# Do enemy commands here
	# Iterate through enemies
	for enemy in enemy_battle_team:
		var random_command: BattleCommand = enemy.battle_commands.pick_random()
	# Randomly select a command and fill out targets
	pass

func _resolve_commands() -> void:
	_turn_state = TURN_STATE.RESOLVING_COMMANDS
	print("_resolve_commands: ", _ally_command_list.commands_view)
	for command: BattleCommand in _ally_command_list.commands_view:
		print("resolving command: ", command.command_name, " source: ", command.source_character, " targets: ", command.targets)
		command.execute()
	_ally_command_list.clear()
	_turn_state = TURN_STATE.SELECTING_CHARACTER
	_check_battle_end()

func _check_battle_end() -> void:
	if _is_team_dead(ally_battle_team) or _is_team_dead(enemy_battle_team):
		_end_battle()

func _is_team_dead(p_team: Array[BattleCharacter]) -> bool:
	for battle_character in p_team:
		if not battle_character.is_dead():
			return false
	return true

func _end_battle() -> void:
	print("ending battle")
	_current_character = null
	_current_command = null
	ally_battle_team = []
	enemy_battle_team = []
	_ally_command_list.clear()
	_target_provider = null
	_turn_state = TURN_STATE.OTHER
	exit_battle_requested.emit()

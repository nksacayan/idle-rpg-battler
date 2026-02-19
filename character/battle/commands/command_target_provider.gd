extends RefCounted
class_name CommandTargetProvider

# TODO: We currently don't have a way to exit early if num targets
#  < max but > min
var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]

func add_target_to_command(p_command: BattleCommand, p_target_character: BattleCharacter) -> bool:
	if ally_battle_team.is_empty() or enemy_battle_team.is_empty():
		push_error("Did not initialize battle teams for targeter")
		return false
	if not p_command:
		push_error("Command not valid")
		return false
	if has_maximum_targets(p_command):
		push_error("Tried to add a target to a command with max targets")
		return false
	if not _is_target_type_valid(p_command, p_target_character):
		push_warning("Target type not valid")
		return false
	if p_target_character in p_command.targets:
		push_warning("Duplicate targets not allowed (TBD)")
		return false
	
	p_command.targets.append(p_target_character)
	return true

func _is_target_type_valid(p_command: BattleCommand, p_target_character: BattleCharacter) -> bool:
	if p_target_character == p_command.source_character and not p_command.target_types.has(BattleCommand.TARGET_TYPE.SELF):
		push_warning("Tried to add SELF to invalid command")
		return false;
	if ally_battle_team.has(p_target_character) and not p_command.target_types.has(BattleCommand.TARGET_TYPE.ALLY):
		push_warning("Tried to add ALLY to invalid command")
		return false;
	if enemy_battle_team.has(p_target_character) and not p_command.target_types.has(BattleCommand.TARGET_TYPE.ENEMY):
		push_warning("Tried to add ENEMY to invalid command")
		return false;
	return true

func has_maximum_targets(p_command: BattleCommand) -> bool:
	return p_command.targets.size() >= p_command.max_targets

func _init(p_ally_battle_team: Array[BattleCharacter], p_enemy_battle_team: Array[BattleCharacter]) -> void:
	ally_battle_team = p_ally_battle_team
	enemy_battle_team = p_enemy_battle_team

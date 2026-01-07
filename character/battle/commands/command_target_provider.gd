extends RefCounted
class_name CommandTargetProvider


var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]

func add_target_to_command(p_command: BattleCommand, p_target_character: BattleCharacter) -> bool:
    if not is_instance_valid(ally_battle_team) or not is_instance_valid(enemy_battle_team):
        push_error("Did not initialize battle teams for targeter")
        return false
    if not is_instance_valid(p_command):
        push_error("Command not valid")
        return false
    if p_command.targets.size() > p_command.max_targets:
        push_error("Tried to add a target to a command with max targets")
        return false
    if not _is_target_type_valid(p_command, p_target_character):
        return false
    
    p_command.targets.append(p_target_character)
    return true

func _is_target_type_valid(p_command: BattleCommand, p_target_character: BattleCharacter) -> bool:
    if p_target_character == p_command.source_character and not p_command.target_types.has(BattleCommand.TARGET_TYPE.SELF):
        return false;
    if ally_battle_team.has(p_target_character) and not p_command.target_types.has(BattleCommand.TARGET_TYPE.ALLY):
        return false;
    if enemy_battle_team.has(p_target_character) and not p_command.target_types.has(BattleCommand.TARGET_TYPE.ENEMY):
        return false;
    return true

func has_maximum_targets(p_command: BattleCommand) -> bool:
    return p_command.max_targets <= p_command.targets.size()

func _init(p_ally_battle_team: Array[BattleCharacter], p_enemy_battle_team: Array[BattleCharacter]) -> void:
    ally_battle_team = p_ally_battle_team
    enemy_battle_team = p_enemy_battle_team
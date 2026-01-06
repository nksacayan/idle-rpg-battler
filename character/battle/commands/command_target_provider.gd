extends RefCounted
class_name CommandTargetProvider

signal max_targets_reached

var ally_battle_team: Array[BattleCharacter]
var enemy_battle_team: Array[BattleCharacter]

func add_target_to_command(p_command: BattleCommand, p_battle_character: BattleCharacter) -> void:
    if not is_instance_valid(ally_battle_team) or not is_instance_valid(enemy_battle_team):
        push_warning("Did not initialize battle teams for targeter")
        return
    if not is_instance_valid(p_command):
        return
    if p_command.targets.size() > p_command.max_targets:
        return
    
    p_command.targets.append(p_battle_character)
    
    if p_command.targets.size() == p_command.max_targets:
        max_targets_reached.emit()

func _init(p_ally_battle_team: Array[BattleCharacter], p_enemy_battle_team: Array[BattleCharacter]) -> void:
    ally_battle_team = p_ally_battle_team
    enemy_battle_team = p_enemy_battle_team
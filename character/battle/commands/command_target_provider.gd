extends RefCounted
class_name CommandTargetProvider

signal max_targets_reached

var command: BattleCommand

func provide_target(p_battle_character: BattleCharacter) -> void:
    if not is_instance_valid(command):
        return
    if command.targets.size() > command.max_targets:
        return
    
    command.targets.append(p_battle_character)
    
    if command.targets.size() == command.max_targets:
        max_targets_reached.emit()
extends Resource
class_name CommandUnlock

@export var command: BattleCommand
@export var requirements: Array[UnlockRequirement]

func can_unlock(p_character: CharacterData) -> bool:
    for req in requirements:
        if not req.is_satisfied(p_character):
            return false
    return true
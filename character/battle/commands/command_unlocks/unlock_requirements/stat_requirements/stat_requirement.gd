extends CommandUnlockRequirement
class_name StatRequirement

@export var stat_name: CharacterData.STAT_NAMES
@export var required_level: int

func is_satisfied(p_character: CharacterData) -> bool:
    if p_character.stats[stat_name].stat_value.value < required_level:
        return false
    return true
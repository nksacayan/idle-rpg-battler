extends TaskDefinition
class_name TrainingTask

@export var related_stat: CharacterData.STAT_NAMES = CharacterData.STAT_NAMES.STRENGTH
@export var exp_reward: int = 0

func give_reward(_p_character_data: CharacterData) -> void:
    _p_character_data.stats[related_stat].experience += exp_reward

func get_tick_amount(_p_character_data: CharacterData) -> float:
    return DEFAULT_TICK_AMOUNT
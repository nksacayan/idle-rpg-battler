extends TaskReward
class_name StatExpReward

# TODO: dunno if i want exp hard configured maybe change later
@export var exp_amount: int
@export var related_stat: CharacterData.STAT_NAMES

func give_reward(_p_character_data: CharacterData) -> void:
    _p_character_data.stats[related_stat].experience += exp_amount
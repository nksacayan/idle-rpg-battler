# may have to make this abstract later when i want to strategy pattern the tick_amount
extends Resource
class_name TaskDefinition

# figure out dynamic tick values later
const DEFAULT_TICK_AMOUNT := 50
const MAX_PROGRESS := 100.0
const MIN_PROGRESS := 0.0
@export var task_name: String
@export var rewards: Array[TaskReward]

# For now passing character data but might move to a context object down the road
#  for flexability
func get_tick_amount(_p_character_data: CharacterData) -> float:
    return DEFAULT_TICK_AMOUNT

func give_rewards(_p_character_data: CharacterData) -> void:
    for reward in rewards:
        reward.give_reward(_p_character_data)
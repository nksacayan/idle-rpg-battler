@abstract
extends Resource
class_name TaskDefinition

# figure out dynamic tick values later
const DEFAULT_TICK_AMOUNT := 50
const MAX_PROGRESS := 100.0
const MIN_PROGRESS := 0.0
@export var task_name: String

# For now passing character data but might move to a context object down the road
#  for flexability
@abstract func get_tick_amount(_p_character_data: CharacterData) -> float
@abstract func give_reward(_p_character_data: CharacterData) -> void
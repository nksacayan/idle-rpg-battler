@abstract
extends Resource
class_name TaskReward

# might need to move to a context object at some point
#  for now just pass character
@export var reward_name: String

@abstract func give_reward(_p_character_data: CharacterData)
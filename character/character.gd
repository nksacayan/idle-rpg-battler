extends Resource
class_name Character

@export var character_name: String
@export var character_stats: CharacterStats

func _init(p_character_name: String):
	character_name = p_character_name
	character_stats = CharacterStats.new()

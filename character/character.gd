extends RefCounted
class_name Character

var character_name: String
var character_stats: CharacterStats

func _init(p_character_name: String):
	character_name = p_character_name
	character_stats = CharacterStats.new()

extends RefCounted
class_name Character

var character_stats: CharacterStats

func _init():
	character_stats = CharacterStats.new()
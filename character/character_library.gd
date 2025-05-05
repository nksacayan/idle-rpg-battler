extends Node

var character_library: Array[Character] = []

func create_new_character(p_character_name: String = "Default Name"):
	character_library.append(Character.new(p_character_name))

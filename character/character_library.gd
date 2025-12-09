extends Node
class_name CharacterLibrary

signal character_added(p_character: Character)
var _character_library: Array[Character] = []

func add_character(p_character: Variant) -> void:
	var new_character: Character = null
	if p_character is Character:
		new_character = p_character
	elif p_character is String:
		new_character = Character.new(p_character)
	else:
		push_error("Bad type provided to " + get_class() + "::" + UtilsNks.get_function_name())
		return

	_character_library.append(new_character)
	character_added.emit(new_character)

func remove_character(p_character: Character) -> void:
	_character_library.erase(p_character)
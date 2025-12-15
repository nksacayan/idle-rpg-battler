extends Node
class_name CharacterManager

@export var characters: Array[Character]

func create_character(p_character_name: String = "") -> void:
    if p_character_name.is_empty():
        characters.append(Character.new())
    else:
        characters.append(Character.new(p_character_name))
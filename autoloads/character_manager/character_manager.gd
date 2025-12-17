extends Node
class_name CharacterManager

signal character_created(character: Character)

@export var characters: Array[Character]

func create_character(p_character_name: String = "") -> void:
    var new_character: Character
    if p_character_name.is_empty():
        new_character = Character.new()
        characters.append(new_character)
    else:
        new_character = Character.new(p_character_name)
        characters.append(new_character)
    character_created.emit(new_character)
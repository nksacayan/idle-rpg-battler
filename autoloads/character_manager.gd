extends Node
class_name CharacterManager

@export var character_stat_definitions: Array[CharacterStatDefinition]
@export var characters: Array[Character]

func _ready() -> void:
    _setup_character_stat_definitions()
    create_character()

func _setup_character_stat_definitions() -> void:
    assert(!character_stat_definitions.is_empty(), "CharacterManager was not given stat definitions before runtime")
    Character.character_stat_definitions = character_stat_definitions

func create_character(p_character_name: String = "") -> void:
    if p_character_name.is_empty():
        characters.append(Character.new())
    else:
        characters.append(Character.new(p_character_name))
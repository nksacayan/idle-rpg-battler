extends Node2D

@export var test_definitions: Array[CharacterStatDefinition]
var test_character: Character

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Character.character_stat_definitions = test_definitions
	test_character = Character.new();
	pass # Replace with function body.
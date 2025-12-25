extends Control

@export var character_card_root: CharacterCard
@onready var character: Character = character_card_root.character
@onready var name_label: Label = %NameLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

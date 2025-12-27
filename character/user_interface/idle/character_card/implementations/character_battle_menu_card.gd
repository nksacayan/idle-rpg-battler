extends Control

@export var character_card_root: CharacterCard
@onready var character: CharacterOld = character_card_root.character
@onready var name_label: Label = %NameLabel

func _ready() -> void:
	name_label.text = character.character_name

func remove_from_battle_team() -> void:
	CharacterManagerAutoload.remove_from_battle_team(character)

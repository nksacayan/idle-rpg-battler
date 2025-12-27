extends Control

# Connect this signal in editor
signal card_delete_requested

@export var character_card_root: CharacterCard
@onready var character: Character = character_card_root.character
@onready var name_label: Label = %NameLabel

func _ready() -> void:
	name_label.text = character.character_name
	CharacterManagerAutoload.removed_from_battle_team.connect(_handle_battle_team_character_removed)

func _handle_battle_team_character_removed(p_character: Character) -> void:
	if p_character == character:
		card_delete_requested.emit()

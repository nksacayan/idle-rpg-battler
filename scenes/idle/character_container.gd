extends Container

signal request_character_details(p_character_data: CharacterData)

@export var character_card_scene: PackedScene

func _ready() -> void:
	_subscribe_to_character_manager()

func _subscribe_to_character_manager() -> void:
	CharacterManagerAutoload.character_created.connect(_create_character_card)

func _create_character_card(p_character: CharacterData) -> void:
	var new_character_card: CharacterTrainingCard = character_card_scene.instantiate()
	new_character_card.character = p_character
	new_character_card.character_details_requested.connect(request_character_details.emit)
	add_child(new_character_card)

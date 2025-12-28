extends Container

@export var character_card_scene: PackedScene

func _ready() -> void:
	_subscribe_to_character_manager()

func _subscribe_to_character_manager() -> void:
	CharacterManagerAutoload.character_created.connect(_create_character_card)

func _create_character_card(p_character: CharacterData) -> void:
	var new_character_card: CharacterCard = character_card_scene.instantiate()
	new_character_card.character = p_character
	add_child(new_character_card)

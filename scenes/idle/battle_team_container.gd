extends Container

@export var character_card_scene: PackedScene
var character_cards: Array[CharacterCard]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CharacterManagerAutoload.added_to_battle_team.connect(add_character)
	CharacterManagerAutoload.removed_from_battle_team.connect(remove_character)

func add_character(p_character: CharacterOld) -> void:
	var character_card: CharacterCard = character_card_scene.instantiate()
	character_card.character = p_character
	add_child(character_card)
	character_cards.append(character_card)

func remove_character(p_character: CharacterOld) -> void:
	var cards_to_remove: Array[CharacterCard] = character_cards.filter(
		func(card: CharacterCard) -> bool:
			return p_character == card.character
	)
	# TODO: I'm too lazy to error check dupes i should write a util lmao
	# cards_to_remove should always be one
	for card: CharacterCard in cards_to_remove:
		character_cards.erase(card)
		card.queue_free()

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is CharacterOld

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	CharacterManagerAutoload.add_to_battle_team(data as CharacterOld)

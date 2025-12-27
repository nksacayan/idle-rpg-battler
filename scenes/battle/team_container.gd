extends HBoxContainer

@export var character_battle_card: PackedScene
var character_battle_team: Array[CharacterOld]
var character_battle_cards: Array[CharacterBattleCard]

func _ready() -> void:
	for character: CharacterOld in character_battle_team:
		var battle_card: CharacterBattleCard = character_battle_card.instantiate()
		battle_card.character = character
		add_child(battle_card)
		character_battle_cards.append(battle_card)
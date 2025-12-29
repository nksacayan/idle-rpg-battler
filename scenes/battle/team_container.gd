extends HBoxContainer
class_name BattleTeamContainer

@export var character_battle_card: PackedScene
var character_battle_cards: Array[CharacterBattleCard]

func setup(p_character_battle_team: Array[CharacterData]) -> void:
	for character_data: CharacterData in p_character_battle_team:
		var battle_card: CharacterBattleCard = character_battle_card.instantiate()
		character_battle_cards.append(battle_card)
		battle_card.setup(BattleCharacter.new(character_data))
		add_child(battle_card)

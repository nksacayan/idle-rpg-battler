extends HBoxContainer
class_name BattleTeamContainer

@export var character_battle_card: PackedScene
var _character_battle_cards: Array[CharacterBattleCard]

func setup(p_character_battle_team: Array[BattleCharacter]) -> void:
	for card: CharacterBattleCard in _character_battle_cards:
		card.queue_free()
	_character_battle_cards.clear()

	for battle_character: BattleCharacter in p_character_battle_team:
		var battle_card: CharacterBattleCard = character_battle_card.instantiate()
		battle_card.battle_character = battle_character
		add_child(battle_card)
		_character_battle_cards.append(battle_card)

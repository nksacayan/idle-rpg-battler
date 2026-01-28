extends HBoxContainer
class_name BattleTeamContainer

signal character_selected(p_battle_character: BattleCharacter)

@export var character_battle_card_scene: PackedScene

## Setting this variable automatically refreshes the UI
var battle_team: Array[BattleCharacter] = []:
	set(value):
		battle_team = value
		_update_ui()

## Holds references to active cards
var _card_nodes: Array[SelectableBattleCharacterCard] = []

func _update_ui() -> void:
	# 1. Immediate removal from tree (Safety)
	# This prevents old cards from receiving inputs while waiting to be freed.
	for card in _card_nodes:
		if is_instance_valid(card):
			# Disconnect to prevent signals firing during deletion
			if card.character_selected.is_connected(_on_card_selected):
				card.character_selected.disconnect(_on_card_selected)
			card.queue_free()
	
	_card_nodes.clear()

	# 2. Build new UI from the data
	for battle_character in battle_team:
		var card := character_battle_card_scene.instantiate() as SelectableBattleCharacterCard
		
		# Inject data and connect
		card.battle_character = battle_character
		card.character_selected.connect(_on_card_selected)
		
		add_child(card)
		_card_nodes.append(card)

func _on_card_selected(p_battle_character: BattleCharacter) -> void:
	character_selected.emit(p_battle_character)

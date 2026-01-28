extends BattleCharacterCardNew
class_name SelectableBattleCharacterCard

signal character_selected(p_battle_character: BattleCharacter)

func _on_character_selected() -> void:
	character_selected.emit(battle_character)
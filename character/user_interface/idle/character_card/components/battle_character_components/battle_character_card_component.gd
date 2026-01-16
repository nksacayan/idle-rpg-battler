@abstract
extends Control
class_name BattleCharacterCardComponent

var character: BattleCharacter:
	set = _set_character

# To allow overrides
func _set_character(p_character: BattleCharacter) -> void:
	character = p_character
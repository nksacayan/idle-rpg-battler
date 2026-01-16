extends CharacterCardComponent

func _enter_tree() -> void:
	provide_drag_impl = false
	provide_drop_impl = false

func _remove_character_from_battle_team() -> void:
	CharacterManagerAutoload.remove_from_battle_team(character)
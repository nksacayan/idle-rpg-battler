extends Node
class_name IdleMain

signal begin_battle_requested

func _start_battle() -> void:
	print("Start battle requested")
	if not CharacterManagerAutoload.battle_team.is_empty():
		begin_battle_requested.emit()

extends Node
class_name IdleMain

signal begin_battle_requested

func _start_battle() -> void:
	print("Start battle requested")
	begin_battle_requested.emit()

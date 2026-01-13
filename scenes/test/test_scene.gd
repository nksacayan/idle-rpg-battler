extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var leveled_stat = LeveledStat.new()
	print("name: ", leveled_stat.stat_name)
	leveled_stat.stat_name = "test"
	print("name: ", leveled_stat.stat_name)
	pass # Replace with function body.


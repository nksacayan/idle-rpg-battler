extends Resource
class_name CharacterStats

@export var base_stats: Array[BaseStat]

func _init():
	_init_base_stats()

func _init_base_stats():
	for stat: BaseStat.StatNames in BaseStat.StatNames.values():
			base_stats[stat] = BaseStat.new()

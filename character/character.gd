extends Resource
class_name Character

@export var character_name: String
@export var base_stats: Array[BaseStat]


func _init(p_character_name: String = "Default Name"):
	character_name = p_character_name
	_init_base_stats()

func _init_base_stats():
	for stat: BaseStat.StatNames in BaseStat.StatNames.values():
			base_stats.append(BaseStat.new(stat))
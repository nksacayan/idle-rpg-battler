extends Resource
class_name Character

@export var character_name: String
@export var base_stats: Array[BaseStatNks]


func _init(p_character_name: String = "Default Name"):
	character_name = p_character_name
	_init_base_stats()

func _init_base_stats():
	for stat: BaseStatNks.StatNames in BaseStatNks.StatNames.values():
			base_stats.append(BaseStatNks.new(stat))
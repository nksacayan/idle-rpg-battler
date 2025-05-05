extends RefCounted
class_name CharacterStats

enum StatNames {
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	WILLPOWER,
	INTELLIGENCE,
	PERCEPTION,
}

var base_stats: Dictionary[StatNames, BaseStat]

func _init():
	_init_base_stats()

func _init_base_stats():
	for stat: StatNames in StatNames.values():
			base_stats[stat] = BaseStat.new()

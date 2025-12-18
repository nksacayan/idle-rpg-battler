extends Resource
class_name Character


@export var character_name: String
@export var stats: Array[CharacterStat]
@export var stat_exps: Array[CharacterStatExp]


func _init(p_character_name: String = "default_character_name") -> void:
	character_name = p_character_name
	_init_stats()

# Is tightly coupled to the registry but is simpler and more efficient
func _init_stats() -> void:
	for definition in CharacterStatDefinitionRegistryAutoload.definitions:
		var new_stat = CharacterStat.new(definition)
		stats.append(new_stat)
		stat_exps.append(CharacterStatExp.new(new_stat))

func get_stat(p_stat_definition: CharacterStatDefinition) -> CharacterStat:
	var filtered_stats := stats.filter(func(stat: CharacterStat) -> bool:
		return stat.definition == p_stat_definition
	)

	# Intended that there is only one stat that matches definition, otherwise copies exist
	if filtered_stats.size() > 1:
		push_error("Returned multiple of the same stat")
	elif filtered_stats.size() <= 0:
		push_error("Returned no matching stats")

	return filtered_stats[0]
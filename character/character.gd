extends Resource
class_name CharacterOld


@export var character_name: String
# Don't modify stats directly for progression, use exp
@export var stats: Array[CharacterStatOld]
# stat exp trackers will manage stat progression.
@export var stat_exps: Array[CharacterStatExpOld]


func _init(p_character_name: String = "default_character_name") -> void:
	character_name = p_character_name
	_init_stats()

# Is tightly coupled to the registry but is simpler and more efficient
func _init_stats() -> void:
	for definition in CharacterStatDefinitionRegistryAutoload.definitions:
		var new_stat = CharacterStatOld.new(definition)
		stats.append(new_stat)
		stat_exps.append(CharacterStatExpOld.new(new_stat))

func get_stat(p_stat_definition: CharacterStatDefinition) -> CharacterStatOld:
	var filtered_stats := stats.filter(func(stat: CharacterStatOld) -> bool:
		return stat.definition == p_stat_definition
	)

	# Intended that there is only one stat that matches definition, otherwise copies exist
	if filtered_stats.size() > 1:
		push_error("Returned multiple of the same stat")
	elif filtered_stats.size() <= 0:
		push_error("Returned no matching stats")

	return filtered_stats[0]

func get_stat_exp(p_stat_definition: CharacterStatDefinition) -> CharacterStatExpOld:
	var filtered := stat_exps.filter(func(stat_exp: CharacterStatExpOld) -> bool:
		return stat_exp.managed_stat.definition == p_stat_definition
	)

	# Intended that there is only one stat that matches definition, otherwise copies exist
	if filtered.size() > 1:
		push_error("Returned multiple of the same stat exp")
	elif filtered.size() <= 0:
		push_error("Returned no matching stat exp")

	return filtered[0]
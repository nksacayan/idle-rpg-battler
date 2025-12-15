extends Resource
class_name Character


var character_name: String
var stats: Array[CharacterStat]


func _init(p_character_name: String = "default_character_name") -> void:
	character_name = p_character_name
	_init_stats()

# Is tightly coupled to the registry but is simpler and more efficient
func _init_stats() -> void:
	for definition in CharacterStatDefinitionRegistryAutoload.definitions:
		stats.append(CharacterStat.new(definition))

# func get_stat(p_stat_definition: CharacterStatDefinition) -> CharacterStat:

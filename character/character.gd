extends Resource
class_name Character

# Character definition resources must be provided by some sort of manager
# before first init
static var _character_stat_definitions: Array[CharacterStatDefinition]
static var character_stat_definitions: Array[CharacterStatDefinition]:
	get:
		if _character_stat_definitions.is_empty():
			push_error("Static character stat definitions are empty")
		return _character_stat_definitions
	set(value):
		if !_character_stat_definitions.is_empty():
			push_error("Static character stat definitions have already been provided")
			return
		_character_stat_definitions = value

var character_name: String
var character_stats: Array[CharacterStat]

func _init(p_character_name := "default_character_name") -> void:
	character_name = p_character_name
	_init_character_stats()

func _init_character_stats() -> void:
	for definition in character_stat_definitions:
		character_stats.append(CharacterStat.new(definition))
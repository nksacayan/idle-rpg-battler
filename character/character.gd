extends RefCounted
class_name Character

static var character_stat_definitions: Array[CharacterStatDefinition]

var character_name: String
var character_stats: Array[CharacterStat]

var health := Health.new()

# Note: Not a fan of this way of static initializing, but it's the simplest
# Wanted to have something more configurable in the editor with exported definitions
# but doing that complicated the architecture
static func _static_init() -> void:
	character_stat_definitions = [
		preload("res://character/stat_definitions/strength.tres"),
		preload("res://character/stat_definitions/dexterity.tres"),
		preload("res://character/stat_definitions/constitution.tres"),
		preload("res://character/stat_definitions/wisdom.tres"),
		preload("res://character/stat_definitions/intelligence.tres"),
		preload("res://character/stat_definitions/charisma.tres"),
	]

func _init(p_character_name := "default_character_name") -> void:
	character_name = p_character_name
	_init_character_stats()

func _init_character_stats() -> void:
	for definition in character_stat_definitions:
		character_stats.append(CharacterStat.new(definition))
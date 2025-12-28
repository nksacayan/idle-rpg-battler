extends Resource
class_name CharacterData

enum STAT_NAMES {
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	WISDOM,
	INTELLIGENCE,
	CHARISMA
}

const DEFAULT_CHARACTER_NAME := "DEFAULT NAME"
@export var character_name: String = DEFAULT_CHARACTER_NAME
@export var stats: Dictionary[STAT_NAMES, LeveledStat] = {
	STAT_NAMES.STRENGTH: LeveledStat.new(),
	STAT_NAMES.DEXTERITY: LeveledStat.new(),
	STAT_NAMES.CONSTITUTION: LeveledStat.new(),
	STAT_NAMES.WISDOM: LeveledStat.new(),
	STAT_NAMES.INTELLIGENCE: LeveledStat.new(),
	STAT_NAMES.CHARISMA: LeveledStat.new()
}

# Will probably have to change init or some setup later to get stats to serialize?
func _init(p_character_name: String = DEFAULT_CHARACTER_NAME) -> void:
	character_name = p_character_name
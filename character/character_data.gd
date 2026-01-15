@tool
extends Resource
class_name CharacterData

const STARTING_LEVELED_STAT_VALUE := 1

enum STAT_NAMES {
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	WISDOM,
	INTELLIGENCE,
	CHARISMA
}

const DEFAULT_NAME := "DEFAULT NAME"
@export var character_name: String = DEFAULT_NAME
@export var stats: Dictionary[STAT_NAMES, LeveledStat]
@export var available_battle_commands: Array[BattleCommand]

func _init(p_character_name: String = DEFAULT_NAME) -> void:
	character_name = p_character_name
	_init_stats()

func _init_stats() -> void:
	if stats.is_empty():
		for stat: STAT_NAMES in STAT_NAMES.values():
			stats[stat] = LeveledStat.new(
				BaseStat.new(
					STAT_NAMES.find_key(stat),
					STARTING_LEVELED_STAT_VALUE
				)
			)

@tool
extends Resource
class_name CharacterData

const STARTING_LEVELED_STAT_VALUE := 1

const DEFAULT_NAME := "DEFAULT NAME"
@export var character_name: String = DEFAULT_NAME
@export var stats: Dictionary[Stats.STAT_NAMES, LeveledStat]
@export var masteries: Dictionary[String, BaseStat]
@export var learned_battle_commands: Array[BattleCommand]
@export var equipment: Dictionary[EquipmentProperties.SLOT, Equipment]

func _init(p_character_name: String = DEFAULT_NAME) -> void:
	character_name = p_character_name
	_init_stats()
	_init_equipment()

func _init_stats() -> void:
	if stats.is_empty():
		for stat: Stats.STAT_NAMES in Stats.STAT_NAMES.values():
			stats[stat] = LeveledStat.new(
				BaseStat.new(
					Stats.STAT_NAMES.find_key(stat),
					STARTING_LEVELED_STAT_VALUE
				)
			)

func _init_equipment() -> void:
	if equipment.is_empty():
		for slot: EquipmentProperties.SLOT in EquipmentProperties.SLOT.values():
			equipment[slot] = null

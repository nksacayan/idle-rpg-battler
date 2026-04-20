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

func to_dict() -> Dictionary:
	var stats_dict: Dictionary[int, Dictionary] = {}
	for stat_key: Stats.STAT_NAMES in stats:
		var leveled_stat := stats[stat_key]
		stats_dict[stat_key] = {
			"stat_name": leveled_stat.stat.stat_name,
			"value": leveled_stat.stat.value,
			"experience": leveled_stat.experience,
		}

	var commands_array: Array[String] = []
	for command: BattleCommand in learned_battle_commands:
		commands_array.append(command.command_name)

	return {
		"character_name": character_name,
		"stats": stats_dict,
		"equipment": {},
		"learned_battle_commands": commands_array,
	}

static func from_dict(p_dict: Dictionary) -> CharacterData:
	var character := CharacterData.new(p_dict["character_name"])

	var stats_data: Dictionary[int, Dictionary] = p_dict["stats"]
	for stat_key_int: int in stats_data:
		var stat_key := stat_key_int as Stats.STAT_NAMES
		var stat_data: Dictionary = stats_data[stat_key_int]
		var leveled_stat := character.stats[stat_key]
		leveled_stat.stat.value = stat_data["value"]
		leveled_stat.experience = stat_data["experience"]

	var command_names: Array[String] = p_dict["learned_battle_commands"]
	for command_name: String in command_names:
		var command: BattleCommand = CommandRegistryAutoload.find_command_by_name(command_name)
		if command:
			character.learned_battle_commands.append(command)
		else:
			push_error("CharacterData.from_dict: unknown command '%s'" % command_name)

	return character

extends RefCounted
class_name BattleCharacter

enum DEPLETABLE_STAT_NAMES {
	HEALTH,
	STAMINA,
	MAGIC
}

const DEPLETABLE_PER_STAT = 10

var character_data: CharacterData
var depletable_stats: Dictionary[DEPLETABLE_STAT_NAMES, DepletableStat]

func _init(p_character_data: CharacterData) -> void:
	character_data = p_character_data
	# TODO: Figure out something better for derived stats
	depletable_stats[DEPLETABLE_STAT_NAMES.HEALTH] = DepletableStat.new(character_data.stats[CharacterData.STAT_NAMES.CONSTITUTION].stat_value.value * DEPLETABLE_PER_STAT)
	depletable_stats[DEPLETABLE_STAT_NAMES.STAMINA] = DepletableStat.new(character_data.stats[CharacterData.STAT_NAMES.CONSTITUTION].stat_value.value * DEPLETABLE_PER_STAT)
	depletable_stats[DEPLETABLE_STAT_NAMES.MAGIC] = DepletableStat.new(character_data.stats[CharacterData.STAT_NAMES.INTELLIGENCE].stat_value.value * DEPLETABLE_PER_STAT)
extends RefCounted
class_name BattleCharacter

enum DEPLETABLE_STAT_NAMES {
	HEALTH,
	STAMINA,
	MAGIC,
}

var depletable_stat_formulas: Dictionary[DEPLETABLE_STAT_NAMES, Callable] = {
	DEPLETABLE_STAT_NAMES.HEALTH: StatFormulas.calc_per_constitution,
	DEPLETABLE_STAT_NAMES.STAMINA: StatFormulas.calc_per_constitution,
	DEPLETABLE_STAT_NAMES.MAGIC: StatFormulas.calc_per_intelligence,
}

var character_data: CharacterData
var depletable_stats: Dictionary[DEPLETABLE_STAT_NAMES, DepletableStat]

func _init(p_character_data: CharacterData) -> void:
	character_data = p_character_data
	for stat: DEPLETABLE_STAT_NAMES in DEPLETABLE_STAT_NAMES.values():
		depletable_stats[stat] = DepletableStat.new(
			DEPLETABLE_STAT_NAMES.find_key(stat), 
			depletable_stat_formulas[stat].call(character_data.stats)
		)

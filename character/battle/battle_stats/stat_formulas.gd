extends RefCounted
class_name StatFormulas

# These may be passed as callables so make sure to maintain same parameters
# character resource formulas
# Array[BaseStat]
# In order to keep derived stat flexible we have to get stats by their string name
#  not happy about it but they should still be keyed to the enum

# resource stat formulas
# these have to be updated/upkept manually
static var resource_formula_helpers: Dictionary[BattleCharacter.RESOURCE_NAMES, StatFormulaHelper] = {
	BattleCharacter.RESOURCE_NAMES.HEALTH: StatFormulaHelper.new(calc_per_constitution, [CharacterData.STAT_NAMES.CONSTITUTION]),
	BattleCharacter.RESOURCE_NAMES.STAMINA: StatFormulaHelper.new(calc_per_constitution, [CharacterData.STAT_NAMES.CONSTITUTION]),
	BattleCharacter.RESOURCE_NAMES.MAGIC: StatFormulaHelper.new(calc_per_intelligence, [CharacterData.STAT_NAMES.INTELLIGENCE]),
}
static func calc_per_constitution(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
	var value_per_constitution := 10
	var value := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.CONSTITUTION], value_per_constitution)
	return value

static func calc_per_intelligence(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
	var value_per_intelligence := 10
	return _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.INTELLIGENCE], value_per_intelligence)

# battle stat formulas
# these have to be updated/upkept manually
static var battle_stat_formula_helpers: Dictionary[BattleCharacter.BATTLE_STAT_NAMES, StatFormulaHelper] = {
	BattleCharacter.BATTLE_STAT_NAMES.PHYSICAL_ATTACK: StatFormulaHelper.new(calc_physical_attack, physical_attack_dependencies),
	BattleCharacter.BATTLE_STAT_NAMES.PHYSICAL_DEFENSE: StatFormulaHelper.new(calc_physical_defense, physical_defense_dependencies),
	BattleCharacter.BATTLE_STAT_NAMES.MAGICAL_ATTACK: StatFormulaHelper.new(calc_magical_attack, magical_attack_dependencies),
	BattleCharacter.BATTLE_STAT_NAMES.MAGICAL_DEFENSE: StatFormulaHelper.new(calc_magical_defense, magical_defense_dependencies),
	BattleCharacter.BATTLE_STAT_NAMES.SPEED: StatFormulaHelper.new(calc_speed, speed_dependencies),
}

const physical_attack_dependencies: Array[CharacterData.STAT_NAMES] = [
	CharacterData.STAT_NAMES.STRENGTH,
	CharacterData.STAT_NAMES.DEXTERITY,
]
static func calc_physical_attack(p_base_stats: Array[BaseStat]) -> int:
	var value_per_strength := 8
	var strength_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.STRENGTH))
	var strength_attack := strength_stat.value * value_per_strength
	var value_per_dexterity := 2
	var dexterity_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.DEXTERITY))
	var dexterity_attack := dexterity_stat.value * value_per_dexterity
	return strength_attack + dexterity_attack

const physical_defense_dependencies: Array[CharacterData.STAT_NAMES] = [
	CharacterData.STAT_NAMES.STRENGTH,
	CharacterData.STAT_NAMES.DEXTERITY,
]
static func calc_physical_defense(p_base_stats: Array[BaseStat]) -> int:
	var value_per_strength := 2
	var strength_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.STRENGTH))
	var strength_defense := strength_stat.value * value_per_strength
	
	var value_per_dexterity := 8
	var dexterity_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.DEXTERITY))
	var dexterity_defense := dexterity_stat.value * value_per_dexterity
	
	return strength_defense + dexterity_defense

const magical_attack_dependencies: Array[CharacterData.STAT_NAMES] = [
	CharacterData.STAT_NAMES.INTELLIGENCE,
	CharacterData.STAT_NAMES.WISDOM,
]
static func calc_magical_attack(p_base_stats: Array[BaseStat]) -> int:
	var value_per_intelligence := 10
	var intelligence_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.INTELLIGENCE))
	var intelligence_magic := intelligence_stat.value * value_per_intelligence
	return intelligence_magic

const magical_defense_dependencies: Array[CharacterData.STAT_NAMES] = [
	CharacterData.STAT_NAMES.INTELLIGENCE,
	CharacterData.STAT_NAMES.WISDOM,
]
static func calc_magical_defense(p_base_stats: Array[BaseStat]) -> int:
	var value_per_wisdom := 10
	var wisdom_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.WISDOM))
	var wisdom_defense := wisdom_stat.value * value_per_wisdom
	return wisdom_defense

const speed_dependencies: Array[CharacterData.STAT_NAMES] = [
	CharacterData.STAT_NAMES.DEXTERITY
]
static func calc_speed(p_base_stats: Array[BaseStat]) -> int:
	var value_per_dexterity := 10
	var dexterity_stat: BaseStat = _find_stat_by_name(p_base_stats, _get_base_stat_name(CharacterData.STAT_NAMES.DEXTERITY))
	var speed_value := dexterity_stat.value * value_per_dexterity
	return speed_value

# helpers can deviate as only the above will be callables
static func _calculate_value_per_character_stat(p_base_stat: LeveledStat, value_per_stat: int) -> int:
	return p_base_stat.stat.value * value_per_stat

static func _find_stat_by_name(p_base_stats: Array[BaseStat], p_stat_name: String) -> BaseStat:
	var filtered := p_base_stats.filter(func(p_base_stat) -> bool: return p_base_stat.stat_name == p_stat_name)
	if filtered.size() > 0:
		return filtered[0]
	return null

static func _get_base_stat_name(p_stat_name: CharacterData.STAT_NAMES) -> String:
	return CharacterData.STAT_NAMES.find_key(p_stat_name)

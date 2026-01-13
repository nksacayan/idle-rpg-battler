extends RefCounted
class_name StatFormulas

# These may be passed as callables so make sure to maintain same parameters
# main stat formulas
static func calc_per_constitution(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_constitution := 10
    var value := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.CONSTITUTION], value_per_constitution)
    return value

static func calc_per_intelligence(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_intelligence := 10
    return _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.INTELLIGENCE], value_per_intelligence)

# battle stat formulas
static func calc_physical_attack(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_strength := 8
    var strength_attack := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.STRENGTH], value_per_strength)
    var value_per_dexterity := 2
    var dexterity_attack := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.DEXTERITY], value_per_dexterity)
    return strength_attack + dexterity_attack

static func calc_physical_defense(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_strength := 2
    var strength_defense := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.STRENGTH], value_per_strength)
    var value_per_dexterity := 8
    var dexterity_defense := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.DEXTERITY], value_per_dexterity)
    return strength_defense + dexterity_defense

static func calc_magical_attack(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_intelligence := 10
    var intelligence_magic := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.INTELLIGENCE], value_per_intelligence)
    return intelligence_magic

static func calc_magical_defense(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_wisdom := 10
    var value := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.WISDOM], value_per_wisdom)
    return value

static func calc_speed(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value := _calculate_value_per_character_stat(character_stats[CharacterData.STAT_NAMES.DEXTERITY], 10)
    return value

# helpers can deviate as only the above will be callables
static func _calculate_value_per_character_stat(stat: LeveledStat, value_per_stat: int) -> int:
    return stat.stat.value * value_per_stat
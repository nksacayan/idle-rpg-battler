extends RefCounted
class_name StatFormulas

# These may be passed as callables so make sure to maintain same parameters
static func calc_per_constitution(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_constitution := 10
    var value := _calculate_value_per_stat(character_stats[CharacterData.STAT_NAMES.CONSTITUTION], value_per_constitution)
    return value

static func calc_per_intelligence(character_stats: Dictionary[CharacterData.STAT_NAMES, LeveledStat]) -> int:
    var value_per_intelligence := 10
    return _calculate_value_per_stat(character_stats[CharacterData.STAT_NAMES.INTELLIGENCE], value_per_intelligence)

# helpers can deviate as only the above will be callables
static func _calculate_value_per_stat(stat: LeveledStat, value_per_stat: int) -> int:
    return stat.stat_value.value * value_per_stat
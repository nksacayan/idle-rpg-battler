extends RefCounted
class_name BattleStat

const BATTLE_STAT_MAX_VALUE := 9999

var _stat_name: String
var stat_name: String:
    get:
        return _stat_name
var stat_value: ClampedInt

func _init(p_stat_name: String, p_stat_value: int) -> void:
    _stat_name = p_stat_name
    stat_value = ClampedInt.new(BATTLE_STAT_MAX_VALUE, p_stat_value)
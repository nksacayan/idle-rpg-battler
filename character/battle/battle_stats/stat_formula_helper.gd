extends RefCounted
class_name StatFormulaHelper

var stat_formula: Callable
var base_stats: Array[CharacterData.STAT_NAMES]

func _init(p_stat_formula: Callable, p_base_stats: Array[CharacterData.STAT_NAMES]) -> void:
	stat_formula = p_stat_formula
	base_stats = p_base_stats
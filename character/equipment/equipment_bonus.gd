extends Resource
class_name EquipmentBonus

# TODO: Refactor so it can output any stat?
@export var output_stat: Stats.BATTLE_STAT_NAMES
@export var input_stat: Stats.STAT_NAMES
@export var stat_scale: float
@export var flat_bonus: int
@abstract
extends Resource
class_name BattleEffect

@export var effect_name: String
# use underscore params in case implementations don't need an arg
@abstract func apply_effect(_p_source_character: BattleCharacter, _p_targets: Array[BattleCharacter])
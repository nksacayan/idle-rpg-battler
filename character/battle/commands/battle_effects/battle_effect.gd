@abstract
extends Resource
class_name BattleEffect

@export var effect_name: String
@abstract func apply_effect(p_source_character: BattleCharacter, p_targets: Array[BattleCharacter])
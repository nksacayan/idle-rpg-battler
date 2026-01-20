extends BattleEffect
class_name DamageEffect

# no mixed damage type for now because effects are meant to be composited
enum DAMAGE_TYPES {
	PHYSICAL,
	MAGICAL,
}

@export var base_power: int
# no clue how i want scaling and shit to work so come back later
@export var additive_stat: BattleCharacter.BATTLE_STAT_NAMES
@export var additive_stat_factor: float
@export var damage_type: DAMAGE_TYPES

func apply_effect(_p_source_character: BattleCharacter, _p_targets: Array[BattleCharacter]) -> void:
	var total_power: int = (
		base_power + 
		int(
			_p_source_character.battle_stats[additive_stat].stat_value.value *
			additive_stat_factor
		)
	)
	print("total power from ", _p_source_character, " is ", total_power)
	var defending_stat: BattleCharacter.BATTLE_STAT_NAMES = (
		BattleCharacter.BATTLE_STAT_NAMES.PHYSICAL_DEFENSE if
		damage_type == DAMAGE_TYPES.PHYSICAL else
		BattleCharacter.BATTLE_STAT_NAMES.MAGICAL_DEFENSE
	)
	for target: BattleCharacter in _p_targets:
		var defending_stat_value: int = target.battle_stats[defending_stat].stat_value.value
		print("defending value for ", target, " is ", defending_stat_value)
		var damage = max(total_power - defending_stat_value, 0)
		target.character_resources[BattleCharacter.RESOURCE_NAMES.HEALTH].current -= damage
		print("dealt ", damage, " to ", target);
	print_debug("applying effect ", effect_name, "from source ", _p_source_character, "to target ", _p_targets)

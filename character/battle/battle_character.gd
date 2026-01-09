extends RefCounted
class_name BattleCharacter

const BATTLE_STAT_MAX_VALUE := 9999

enum DEPLETABLE_STAT_NAMES {
	HEALTH,
	STAMINA,
	MAGIC,
}

enum BATTLE_STAT_NAMES {
	PHYSICAL_ATTACK,
	PHYSICAL_DEFENSE,
	MAGICAL_ATTACK,
	MAGICAL_DEFENSE,
	SPEED,
}

var depletable_stat_formulas: Dictionary[DEPLETABLE_STAT_NAMES, Callable] = {
	DEPLETABLE_STAT_NAMES.HEALTH: StatFormulas.calc_per_constitution,
	DEPLETABLE_STAT_NAMES.STAMINA: StatFormulas.calc_per_constitution,
	DEPLETABLE_STAT_NAMES.MAGIC: StatFormulas.calc_per_intelligence,
}

var battle_stat_formulas: Dictionary[BATTLE_STAT_NAMES, Callable] = {
	BATTLE_STAT_NAMES.PHYSICAL_ATTACK: StatFormulas.calc_physical_attack,
	BATTLE_STAT_NAMES.PHYSICAL_DEFENSE: StatFormulas.calc_physical_defense,
	BATTLE_STAT_NAMES.MAGICAL_ATTACK: StatFormulas.calc_magical_attack,
	BATTLE_STAT_NAMES.MAGICAL_DEFENSE: StatFormulas.calc_magical_defense,
	BATTLE_STAT_NAMES.SPEED: StatFormulas.calc_speed,
}

var character_data: CharacterData
var depletable_stats: Dictionary[DEPLETABLE_STAT_NAMES, DepletableStat]
var battle_stats: Dictionary[BATTLE_STAT_NAMES, BattleStat]
var local_battle_commands: Array[BattleCommand]

func _init(p_character_data: CharacterData) -> void:
	character_data = p_character_data
	_init_depletables()
	_init_battle_stats()
	_init_battle_commands()

func _init_depletables() -> void:
	for stat: DEPLETABLE_STAT_NAMES in DEPLETABLE_STAT_NAMES.values():
		depletable_stats[stat] = DepletableStat.new(
			DEPLETABLE_STAT_NAMES.find_key(stat), 
			depletable_stat_formulas[stat].call(character_data.stats)
		)

func _init_battle_stats() -> void:
	for stat: BATTLE_STAT_NAMES in BATTLE_STAT_NAMES.values():
		battle_stats[stat] = BattleStat.new(
			BATTLE_STAT_NAMES.find_key(stat),
			battle_stat_formulas[stat].call(character_data.stats)
		)

func _init_battle_commands() -> void:
	for command: BattleCommand in character_data.available_battle_commands:
		var local_command: BattleCommand = command.duplicate_deep()
		local_command.source_character = self
		local_battle_commands.append(local_command)
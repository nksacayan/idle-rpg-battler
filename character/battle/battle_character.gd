extends RefCounted
class_name BattleCharacter

signal current_command_changed(p_command: BattleCommand)

const BATTLE_STAT_MAX_VALUE := 9999

enum RESOURCE_NAMES {
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

var resource_formulas: Dictionary[RESOURCE_NAMES, Callable] = {
	RESOURCE_NAMES.HEALTH: StatFormulas.calc_per_constitution,
	RESOURCE_NAMES.STAMINA: StatFormulas.calc_per_constitution,
	RESOURCE_NAMES.MAGIC: StatFormulas.calc_per_intelligence,
}

var battle_stat_formulas: Dictionary[BATTLE_STAT_NAMES, Callable] = {
	BATTLE_STAT_NAMES.PHYSICAL_ATTACK: StatFormulas.calc_physical_attack,
	BATTLE_STAT_NAMES.PHYSICAL_DEFENSE: StatFormulas.calc_physical_defense,
	BATTLE_STAT_NAMES.MAGICAL_ATTACK: StatFormulas.calc_magical_attack,
	BATTLE_STAT_NAMES.MAGICAL_DEFENSE: StatFormulas.calc_magical_defense,
	BATTLE_STAT_NAMES.SPEED: StatFormulas.calc_speed,
}

var character_data: CharacterData
var character_resources: Dictionary[RESOURCE_NAMES, BoundedStat]
var battle_stats: Dictionary[BATTLE_STAT_NAMES, BattleStat]
var local_battle_commands: Array[BattleCommand]
var _current_command_ref: BattleCommand
var current_command_ref: BattleCommand:
	set(p_command):
		_current_command_ref = p_command
		current_command_changed.emit(_current_command_ref)

# TODO: Battle stats should update if base stats change
func _init(p_character_data: CharacterData) -> void:
	character_data = p_character_data
	_init_resources()
	_init_battle_stats()
	_init_battle_commands()

func _init_resources() -> void:
	for stat_name in RESOURCE_NAMES:
		var stat_id := RESOURCE_NAMES[stat_name] as RESOURCE_NAMES
		var new_stat := BoundedStat.new(
			BaseStat.new(RESOURCE_NAMES.find_key(stat_id) as String, 
				resource_formulas[stat_id].call(character_data.stats)
			)
		)
		character_resources[stat_id] = new_stat

func _init_battle_stats() -> void:
	for stat_name in BATTLE_STAT_NAMES:
		var stat_id: BATTLE_STAT_NAMES = BATTLE_STAT_NAMES[stat_name]
		var new_battle_stat := BattleStat.new(
			stat_name,
			battle_stat_formulas[stat_id].call(character_data.stats)
		)
		battle_stats[stat_id] = new_battle_stat

func _init_battle_commands() -> void:
	for command: BattleCommand in character_data.available_battle_commands:
		var local_command: BattleCommand = command.duplicate_deep()
		local_command.source_character = self
		local_battle_commands.append(local_command)

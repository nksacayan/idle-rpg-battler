extends RefCounted
class_name BattleCharacter

signal battle_commands_updated

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

var character_data: CharacterData
var character_resources: Dictionary[RESOURCE_NAMES, BoundedStat]
var battle_stats: Dictionary[BATTLE_STAT_NAMES, DerivedStat]
var battle_commands: Array[BattleCommand]:
	set(p_battle_commands):
		# setter will not trigger on modifying array, reassign in place to force setter
		battle_commands = p_battle_commands
		battle_commands_updated.emit()

func _init(p_character_data: CharacterData) -> void:
	character_data = p_character_data
	_init_resources()
	_init_battle_stats()
	_init_battle_commands()

func _init_resources() -> void:
	for resource_name in RESOURCE_NAMES:
		var resource_id := RESOURCE_NAMES[resource_name] as RESOURCE_NAMES
		var resource_formula_helper := StatFormulas.resource_formula_helpers[resource_id]
		var applicable_stats: Array[BaseStat]
		for stat in resource_formula_helper.base_stats:
			applicable_stats.append(character_data.stats[stat].stat)
		var new_stat := BoundedStat.new(
			DerivedStat.new(
				applicable_stats,
				resource_formula_helper.stat_formula,
				resource_name
			)
		)
		character_resources[resource_id] = new_stat

func _init_battle_stats() -> void:
	for stat_name in BATTLE_STAT_NAMES:
		var battle_stat_id := BATTLE_STAT_NAMES[stat_name] as BATTLE_STAT_NAMES
		var stat_formula_helper := StatFormulas.battle_stat_formula_helpers[battle_stat_id]
		var applicable_stats: Array[BaseStat]
		for stat in stat_formula_helper.base_stats:
			applicable_stats.append(character_data.stats[stat].stat)
		# It is important to pass ONLY the base stats that the derived stat needs,
		#  otherwise the derived stat will rerender off of any stat change
		var new_battle_stat := DerivedStat.new(
			applicable_stats,
			stat_formula_helper.stat_formula,
			stat_name
		)
		battle_stats[battle_stat_id] = new_battle_stat

func _init_battle_commands() -> void:
	## Note: Keeping source character assigning logic here for now
	##  since I can't think of another way to assign defaults anyways
	# Add defaults
	var default_attack_command: BattleCommand = \
		CommandRegistryAutoload.default_attack.duplicate_deep()
	default_attack_command.source_character = self
	battle_commands.append(default_attack_command)

	# Add known
	for command: BattleCommand in character_data.learned_battle_commands:
		var local_command: BattleCommand = command.duplicate_deep()
		local_command.source_character = self
		battle_commands.append(local_command)
	
	battle_commands_updated.emit()

func refresh_battle_commands() -> void:
	battle_commands.clear()
	_init_battle_commands()
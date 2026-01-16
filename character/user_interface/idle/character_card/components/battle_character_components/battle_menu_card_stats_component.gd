extends BattleCharacterCardComponent

@onready var battle_stats_label_container := %BattleStatsLabelContainer as BaseStatLabelContainer

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_provide_battle_stats()

func _ready() -> void:
	_provide_battle_stats()

func _provide_battle_stats() -> void:
	if character and is_node_ready():
		var battle_stats: Array[BaseStat]
		battle_stats.assign(character.battle_stats.values())
		battle_stats_label_container.base_stats = battle_stats

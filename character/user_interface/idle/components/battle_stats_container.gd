extends Container
class_name BattleStatsContainer

var battle_stats: BattleCharacter:
	set(p_battle_stats):
		battle_stats = p_battle_stats
		if is_node_ready():
			_update_ui()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if battle_stats:
		_update_ui()

func _update_ui() -> void:
	pass

extends Label
class_name BattleStatLabel
# This is super similar to the base stat label but i'd have to go abstract the stats

var battle_stat: BattleStat:
	set(p_battle_stat):
		battle_stat = p_battle_stat
		battle_stat.stat_value.value_changed.connect(_set_label_text.unbind(1))
		if is_node_ready():
			_update_ui()

func _ready() -> void:
	if battle_stat:
		_update_ui()

func _update_ui() -> void:
	_set_label_text()

func _set_label_text() -> void:
	text = str(battle_stat.stat_name, ": ", battle_stat.stat_value.value)
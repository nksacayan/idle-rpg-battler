extends Label
class_name BaseStatLabel

var base_stat: LeveledStat:
	set(p_stat):
		base_stat = p_stat
		base_stat.leveled_up.connect(_set_label_text)
		if is_node_ready():
			_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if base_stat:
		_set_label_text()

func _set_label_text() -> void:
	text = str(base_stat.stat_name, ": ", base_stat.stat.value)
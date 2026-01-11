extends Container
class_name BaseStatsContainer

# expects BaseStatLabel
@export var label_packed_scene: PackedScene

var character_data: CharacterData:
	set(p_character_data):
		character_data = p_character_data
		if is_node_ready():
			_update_ui()

var stat_labels: Array[BaseStatLabel]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if character_data:
		_update_ui()

func _update_ui() -> void:
	if stat_labels.size() > 0:
		_clear_labels()

	for stat_name in character_data.stats:
		_create_label(stat_name)

func _clear_labels() -> void:
	for label in stat_labels:
		label.queue_free()
	stat_labels.clear()

func _create_label(p_stat_name: CharacterData.STAT_NAMES) -> void:
	var stat := character_data.stats[p_stat_name]
	var new_label := label_packed_scene.instantiate() as BaseStatLabel
	new_label.base_stat = stat
	add_child(new_label)
	stat_labels.append(new_label)
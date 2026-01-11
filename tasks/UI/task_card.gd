extends PanelContainer
class_name TaskCard

var task: TaskDefinition:
	set(value):
		task = value
		if is_node_ready():
			_update_labels()

@onready var name_label: Label = %NameLabel

func _ready() -> void:
	# Initial update after nodes are ready
	_update_labels()

func _update_labels() -> void:
	if task:
		name_label.text = task.task_name
	else:
		name_label.text = "No Task"

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_card: TaskCard = duplicate()
	var preview_wrapper = CenterContainer.new()

	preview_card.custom_minimum_size = self.size
	preview_wrapper.use_top_left = true
	preview_wrapper.add_child(preview_card)

	set_drag_preview(preview_wrapper)
	
	return task

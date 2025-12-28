extends PanelContainer
class_name TaskCard

@export var task: TaskDefinition

@onready var name_label: Label = %NameLabel
@onready var stat_label: Label = %StatLabel
@onready var reward_label: Label = %RewardLabel

func _update_labels() -> void:
	name_label.text = task.task_name
	stat_label.text = "Stat: " + str(CharacterData.STAT_NAMES.keys()[task.related_stat])
	reward_label.text = "Reward: " + str(task.exp_reward) + " XP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_labels()

func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview_card: TaskCard = duplicate()
	var preview_wrapper = CenterContainer.new()

	preview_card.custom_minimum_size = self.size
	preview_wrapper.use_top_left = true
	preview_wrapper.add_child(preview_card)

	set_drag_preview(preview_wrapper)
	return task

extends PanelContainer
class_name TaskCard

@export var task: TaskDefinition

@onready var name_label: Label = %NameLabel
@onready var stat_label: Label = %StatLabel
@onready var reward_label: Label = %RewardLabel

func _update_labels() -> void:
	name_label.text = task.task_name
	stat_label.text = "Stat: " + str(task.related_stat.stat_name)
	reward_label.text = "Reward: " + str(task.exp_reward) + " XP"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_labels()
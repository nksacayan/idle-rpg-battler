extends Resource
class_name CharacterTask

signal progress_updated(p_progress: float)

@export var character: CharacterOld
@export var task: TaskDefinition
@export var progress: float = 0.0:
	set(p_value):
		if p_value > task.max_progress:
			p_value -= task.max_progress
			_reward_exp()
		progress = clampf(p_value, TaskDefinition.MIN_PROGRESS, task.max_progress)
		progress_updated.emit(progress)

func _init(p_character: CharacterOld = null, p_task: TaskDefinition = null) -> void:
	character = p_character
	task = p_task

func _reward_exp() -> void:
	character.get_stat_exp(task.related_stat).current_exp += task.exp_reward
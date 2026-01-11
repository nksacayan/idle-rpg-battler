extends Resource
class_name CharacterTask

signal progress_updated(p_progress: float)

@export var character: CharacterData
@export var task: TaskDefinition
@export var progress: float = 0.0:
	set(p_value):
		if p_value > TaskDefinition.MAX_PROGRESS:
			p_value -= TaskDefinition.MAX_PROGRESS
			task.give_reward(character)
		progress = clampf(p_value, TaskDefinition.MIN_PROGRESS, TaskDefinition.MAX_PROGRESS)
		progress_updated.emit(progress)

func _init(p_character: CharacterData = null, p_task: TaskDefinition = null) -> void:
	character = p_character
	task = p_task

func process_task(delta: float) -> void:
	progress += task.get_tick_amount(character) * delta
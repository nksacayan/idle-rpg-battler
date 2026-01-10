extends Node
class_name CharacterTaskManager
# Keep this global since i think i want tasks to ALWAYS tick, even while in battle

signal character_task_added(p_character_task: CharacterTask)
signal character_task_removed(p_character_task: CharacterTask)

@export var character_tasks: Array[CharacterTask]
# TODO: Change this and make it rely on character or task or something
const VALUE_PER_TICK: int = 100

func _process(delta: float) -> void:
	for character_task in character_tasks:
		character_task.progress += VALUE_PER_TICK * delta

# a character should only have one task at a time
func create_character_task(p_character: CharacterData, p_task: TaskDefinition) -> void:
	var existing_tasks: Array[CharacterTask] = character_tasks.filter(
		func(task: CharacterTask) -> bool:
			return p_character == task.character
	)
	if existing_tasks.size() > 0:
		for task: CharacterTask in existing_tasks:
			delete_character_task(task)
	var character_task := CharacterTask.new(p_character, p_task)
	character_tasks.append(character_task)
	character_task_added.emit(character_task)

func delete_character_task(p_character_task: CharacterTask) -> void:
	character_tasks.erase(p_character_task)
	character_task_removed.emit(p_character_task)

func delete_character_task_by_character(p_character: CharacterData) -> void:
	var filtered_tasks := character_tasks.filter(
		func(p_task: CharacterTask) -> bool: return p_task.character == p_character
	)
	# should just be one task but being safe
	for task: CharacterTask in filtered_tasks:
		delete_character_task(task)


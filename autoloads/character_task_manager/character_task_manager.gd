extends Node
class_name CharacterTaskManager

signal character_task_added(p_character_task: CharacterTask)

@export var character_tasks: Array[CharacterTask]
# TODO: Change this and make it rely on character or task or something
const VALUE_PER_TICK: int = 100

# Physics accuracy not necessary, but putting it here to reduce number of ticks for performance
func _physics_process(delta: float) -> void:
	for character_task in character_tasks:
		character_task.progress += VALUE_PER_TICK * delta

func create_character_task(p_character: Character, p_task: TaskDefinition) -> void:
	var character_task := CharacterTask.new(p_character, p_task)
	character_tasks.append(character_task)
	character_task_added.emit(character_task)
extends Node
class_name CharacterTaskManager

@export var character_tasks: Array[CharacterTask]
# TODO: Change this and make it rely on character or task or something
const VALUE_PER_TICK: int = 1

# Physics accuracy not necessary, but putting it here to reduce number of ticks for performance
func _physics_process(delta: float) -> void:
	for character_task in character_tasks:
		character_task.progress += VALUE_PER_TICK * delta
extends Node
class_name CharacterTaskDefinitionRegistry

# TODO: Abstract our definition registries later? They are hardcoded per type
var _definitions: Array[TaskDefinition]
var definitions: Array[TaskDefinition]:
	get: return _definitions.duplicate()

func find_task_definition_by_name(p_name: String) -> TaskDefinition:
	return TaskDefinition.new()
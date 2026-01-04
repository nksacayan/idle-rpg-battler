extends Node
class_name TaskDefinitionRegistry

# TODO: Abstract our definition registries later? They are hardcoded per type
@export var _definitions: Array[TaskDefinition]
var definitions_view: Array[TaskDefinition]:
	get: return _definitions

func find_task_definition_by_name(p_name: String) -> TaskDefinition:
	var filtered = definitions_view.filter(
		func(definition: TaskDefinition) -> bool:
			return definition.task_name == p_name
	)

		# Intended that there is only one stat that matches definition, otherwise copies exist
	if filtered.size() > 1:
		push_error("Returned multiple of the same task")
	elif filtered.size() <= 0:
		push_error("Returned no matching task")

	return filtered[0]
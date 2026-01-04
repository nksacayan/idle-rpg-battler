extends VBoxContainer
class_name TaskContainer

@export var task_card_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_all_cards_from_registry()

func _create_all_cards_from_registry() -> void:
	for task_definition: TaskDefinition in TaskDefinitionRegistryAutoload.definitions_view:
		create_task_card(task_definition)

func create_task_card(p_task: TaskDefinition) -> void:
	var task_card: TaskCard = task_card_scene.instantiate()
	task_card.task = p_task
	add_child(task_card)

extends PanelContainer

@export var character_card_root: CharacterCard
@onready var character: CharacterData = character_card_root.character
var character_task: CharacterTask
@export var provide_drop_data_implementation: bool = false

@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar

func _ready() -> void:
		_subscribe_to_character_task_signals()
		if provide_drop_data_implementation:
			_provide_drop_data_implementation()

func _subscribe_to_character_task_signals() -> void:
	CharacterTaskManagerAutoload.character_task_added.connect(_handle_character_task_created)
	CharacterTaskManagerAutoload.character_task_removed.connect(_handle_character_task_removed)

func _handle_character_task_created(p_character_task: CharacterTask) -> void:
	if p_character_task.character == character:
		character_task = p_character_task
		task_label.text = "Task: " + str(character_task.task.task_name)
		character_task.progress_updated.connect(_update_progress_bar_value)

func _handle_character_task_removed(p_character_task: CharacterTask) -> void:
	if p_character_task == character_task:
		character_task.progress_updated.disconnect(_update_progress_bar_value)
		character_task = null
		task_label.text = "Task: None"
		task_progress_bar.value = 0

func _call_clear_character_task() -> void:
	CharacterTaskManagerAutoload.delete_character_task(character_task)

func _update_progress_bar_value(p_value: float) -> void:
	task_progress_bar.value = p_value

func _can_drop_data_implementation(_at_position: Vector2, data: Variant) -> bool:
		return data is TaskDefinition

func _drop_data_implementation(_at_position: Vector2, data: Variant) -> void:
		CharacterTaskManagerAutoload.create_character_task(character, data as TaskDefinition)

func _provide_drop_data_implementation() -> void:
	character_card_root.can_drop_data_implementation = _can_drop_data_implementation
	character_card_root.drop_data_implementation = _drop_data_implementation

func _on_clear_task_button_pressed() -> void:
	_call_clear_character_task()
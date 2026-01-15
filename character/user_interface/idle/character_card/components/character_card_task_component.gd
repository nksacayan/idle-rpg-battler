extends CharacterCardComponent
class_name CharacterTaskComponent

var character_task: CharacterTask

@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar

func _enter_tree() -> void:
	provide_drag_impl = false

func _ready() -> void:
	_subscribe_to_character_task_signals()
	_refresh_task_status()

func _exit_tree() -> void:
	# Always cleanup global signals to prevent memory leaks
	CharacterTaskManagerAutoload.character_task_added.disconnect(_handle_character_task_created)
	CharacterTaskManagerAutoload.character_task_removed.disconnect(_handle_character_task_removed)

func _refresh_task_status() -> void:
	# Logic to find if this character has a task in the Autoload
	pass

func _subscribe_to_character_task_signals() -> void:
	CharacterTaskManagerAutoload.character_task_added.connect(_handle_character_task_created)
	CharacterTaskManagerAutoload.character_task_removed.connect(_handle_character_task_removed)

func _handle_character_task_created(p_character_task: CharacterTask) -> void:
	if p_character_task.character == character:
		# Clean up existing connection first
		if is_instance_valid(character_task):
			character_task.progress_updated.disconnect(_update_progress_bar_value)
			
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

func can_drop_data_impl(_pos: Vector2, _data: Variant) -> bool:
		return _data is TaskDefinition

func drop_data_impl(_pos: Vector2, _data: Variant) -> void:
		CharacterTaskManagerAutoload.create_character_task(character, _data as TaskDefinition)
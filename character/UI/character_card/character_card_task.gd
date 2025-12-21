extends Control

@export var character_card_root: CharacterCardRoot
var character: Character = character_card_root.character
var character_task: CharacterTask

@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		_subscribe_to_character_task_signals()


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
		character_task = null
		task_label.text = "Task: None"
		task_progress_bar.value = 0

func _call_clear_character_task() -> void:
	CharacterTaskManagerAutoload.delete_character_task(character_task)

func _update_progress_bar_value(p_value: float) -> void:
	task_progress_bar.value = p_value
extends PanelContainer
class_name CharacterCard

# export for testability, not necessary for function as it shouldn't be
# instantiated without a character
@export var character: Character
var character_task: CharacterTask

# TODO: Make this render dynamically per stats on a character
@onready var character_name_label: Label = %CharacterNameLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var constitution_label: Label = %ConstitutionLabel
@onready var wisdom_label: Label = %WisdomLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel
@onready var task_label: Label = %TaskLabel
@onready var task_progress_bar: ProgressBar = %TaskProgressBar

func _ready() -> void:
	_update_labels()
	_subscribe_to_character_stat_changed()
	_subscribe_to_character_task_signals()

# TODO: This update is not performant, might need to optimize down the road when we have lots of characters
func _subscribe_to_character_stat_changed() -> void:
	for stat in character.stats:
		# Ignoring emitted value for now, will need to optimize
		stat.value_changed.connect(_update_labels.unbind(1))

func _subscribe_to_character_task_signals() -> void:
	CharacterTaskManagerAutoload.character_task_added.connect(_handle_character_task_created)
	CharacterTaskManagerAutoload.character_task_removed.connect(_handle_character_task_removed)

func _update_labels() -> void:
	character_name_label.text = character.character_name
	strength_label.text = "Strength: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.strength_definition).value)
	dexterity_label.text = "Dexterity: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.dexterity_definition).value)
	constitution_label.text = "Constitution: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.constitution_definition).value)
	wisdom_label.text = "Wisdom: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.wisdom_definition).value)
	intelligence_label.text = "Intelligence: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.intelligence_definition).value)
	charisma_label.text = "Charisma: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.charisma_definition).value)

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

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return data is TaskDefinition

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	CharacterTaskManagerAutoload.create_character_task(character, data as TaskDefinition)

func _on_clear_task_button_pressed() -> void:
	_call_clear_character_task()

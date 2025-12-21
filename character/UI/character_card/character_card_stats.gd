extends Control

@export var character_card_root: CharacterCardRoot
var character: Character = character_card_root.character

# TODO: Make this render dynamically per stats on a character
@onready var character_name_label: Label = %CharacterNameLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var constitution_label: Label = %ConstitutionLabel
@onready var wisdom_label: Label = %WisdomLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel

func _ready() -> void:
	_subscribe_to_character_stat_changed()

# TODO: This update is not performant, might need to optimize down the road when we have lots of characters
func _subscribe_to_character_stat_changed() -> void:
	for stat in character.stats:
		# Ignoring emitted value for now, will need to optimize
		stat.value_changed.connect(_update_labels.unbind(1))

func _update_labels() -> void:
	character_name_label.text = character.character_name
	strength_label.text = "Strength: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.strength_definition).value)
	dexterity_label.text = "Dexterity: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.dexterity_definition).value)
	constitution_label.text = "Constitution: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.constitution_definition).value)
	wisdom_label.text = "Wisdom: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.wisdom_definition).value)
	intelligence_label.text = "Intelligence: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.intelligence_definition).value)
	charisma_label.text = "Charisma: " + str(character.get_stat(CharacterStatDefinitionRegistryAutoload.charisma_definition).value)
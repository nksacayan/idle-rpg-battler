extends PanelContainer

@export var character: Character

@onready var character_name_label: Label = %CharacterNameLabel
@onready var strength_label: Label = %StrengthLabel
@onready var dexterity_label: Label = %DexterityLabel
@onready var constitution_label: Label = %ConstitutionLabel
@onready var wisdom_label: Label = %WisdomLabel
@onready var intelligence_label: Label = %IntelligenceLabel
@onready var charisma_label: Label = %CharismaLabel

func _ready() -> void:
	pass # Replace with function body.

func _update_labels() -> void:
	character_name_label.text = character.character_name

extends PanelContainer

@export var character_card_root: CharacterCard
@onready var character: CharacterData = character_card_root.character

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
	_update_labels()

# TODO: This update is not performant, might need to optimize down the road when we have lots of characters
func _subscribe_to_character_stat_changed() -> void:
	for stat: LeveledStat in character.stats.values():
		# Ignoring emitted value for now, will need to optimize
		stat.stat.value_changed.connect(_update_labels.unbind(1))

func _update_labels() -> void:
	character_name_label.text = character.character_name
	strength_label.text = "Strength: " + str(character.stats[CharacterData.STAT_NAMES.STRENGTH].stat_value.value)
	dexterity_label.text = "Dexterity: " + str(character.stats[CharacterData.STAT_NAMES.DEXTERITY].stat_value.value)
	constitution_label.text = "Constitution: " + str(character.stats[CharacterData.STAT_NAMES.CONSTITUTION].stat_value.value)
	wisdom_label.text = "Wisdom: " + str(character.stats[CharacterData.STAT_NAMES.WISDOM].stat_value.value)
	intelligence_label.text = "Intelligence: " + str(character.stats[CharacterData.STAT_NAMES.INTELLIGENCE].stat_value.value)
	charisma_label.text = "Charisma: " + str(character.stats[CharacterData.STAT_NAMES.CHARISMA].stat_value.value)

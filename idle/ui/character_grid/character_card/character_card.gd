extends PanelContainer
class_name CharacterCard

@export var character_name_label: Label
@export var character_stats_label: Label

const CHARACTER_STAT_TEMPLATE = "%s: %d\n"

var character: Character


func _ready():
	update_ui()

func update_ui():
	character_name_label.text = character.character_name
	update_character_stats_label()

func update_character_stats_label():
	character_stats_label.text = ""
	for stat: BaseStatNks in character.base_stats:
		character_stats_label.text += CHARACTER_STAT_TEMPLATE % [BaseStatNks.StatNames.keys()[stat.stat_name], stat.stat_value]

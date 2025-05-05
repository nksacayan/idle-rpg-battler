extends PanelContainer

@export var character_name_label: Label
@export var character_stats_label: Label

const CHARACTER_STAT_TEMPLATE = "%s: %d"

var character: Character

func update_ui():
	character_name_label.text = character.character_name

func update_character_stats_label():
	character_stats_label.text = ""
	for stat: BaseStat.StatNames in BaseStat.StatNames.values():
		character_stats_label.text += CHARACTER_STAT_TEMPLATE % [BaseStat.StatNames.keys()[stat], character.character_stats.base_stats[stat]]
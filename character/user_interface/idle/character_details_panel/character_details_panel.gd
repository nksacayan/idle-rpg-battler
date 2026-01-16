extends PanelContainer

@onready var name_label: Label = %NameLabel
@onready var base_stats_container: BaseStatLabelContainer = %BaseStatsVbox

var character: CharacterData:
	set(p_character):
		character = p_character
		if is_node_ready():
			_update_ui()
var battle_data: BattleCharacter

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if character:
		name_label.text = character.character_name
		base_stats_container.character_data = character
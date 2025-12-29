extends PanelContainer
class_name CharacterBattleCard

var _battle_character: BattleCharacter
var battle_character: BattleCharacter:
	set(value):
		_battle_character = value
		
		if is_node_ready():
			_update_ui()

@onready var _name_label: Label = %NameLabel
@onready var _battle_card_container: VBoxContainer = %BattleCardContainer
var _depletable_stat_labels: Array[Label]

func _ready() -> void:
	if _battle_character:
		_update_ui()

func _update_ui() -> void:
	_name_label.text = _battle_character.character_data.character_name
	_generate_depletable_stat_labels()

func _generate_depletable_stat_labels() -> void:
	for label: Label in _depletable_stat_labels:
		label.queue_free()
	_depletable_stat_labels.clear()
			
	for depletable_key in _battle_character.depletable_stats:
		var new_label: Label = _name_label.duplicate()
		var depletable_name: String = BattleCharacter.DEPLETABLE_STAT_NAMES.keys()[depletable_key]
		var depletable_value: String = str(_battle_character.depletable_stats[depletable_key].current)
		new_label.text = depletable_name + ": " + depletable_value
		_battle_card_container.add_child(new_label)

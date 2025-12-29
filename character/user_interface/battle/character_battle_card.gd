extends PanelContainer
class_name CharacterBattleCard

var _battle_character: BattleCharacter
@onready var _name_label: Label = %NameLabel
@onready var _battle_card_container: VBoxContainer = %BattleCardContainer

func setup(p_battle_character) -> void:
	_battle_character = p_battle_character
	_name_label.text = _battle_character.character_data.character_name
	_generate_depletable_stat_labels()

func _generate_depletable_stat_labels() -> void:
	for depletable_key: BattleCharacter.DEPLETABLE_STAT_NAMES in _battle_character.depletable_stats:
		var new_label: Label = _name_label.duplicate()
		var stat_name: String = BattleCharacter.DEPLETABLE_STAT_NAMES.keys()[depletable_key]
		var stat_value: String = str(_battle_character.depletable_stats[depletable_key].current)
		new_label.text = stat_name + ": " + stat_value
		_battle_card_container.add_child(new_label)

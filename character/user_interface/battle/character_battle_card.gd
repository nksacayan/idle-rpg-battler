extends PanelContainer
class_name CharacterBattleCard

signal character_selected(p_battle_character: BattleCharacter)

var _battle_character: BattleCharacter
var battle_character: BattleCharacter:
	set(value):
		_battle_character = value
		_battle_character.current_command_changed.connect(_update_command_label)
		
		if is_node_ready():
			_update_ui()

@onready var _name_label: Label = %NameLabel
@onready var _command_label: Label = %CommandLabel
@onready var _battle_card_container: VBoxContainer = %BattleCardContainer
var _depletable_stat_labels: Array[Label]

func _ready() -> void:
	if _battle_character:
		_update_ui()

func _update_ui() -> void:
	_name_label.text = _battle_character.character_data.character_name
	_update_command_label(_battle_character.current_command_ref)
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
		_battle_character.depletable_stats[depletable_key].changed.connect(
			func(p_value: int) -> void:
				new_label.text = depletable_name + ": " + str(p_value)		
		)
		_battle_card_container.add_child(new_label)

func _on_select_character_pressed() -> void:
	character_selected.emit(_battle_character)

func _update_command_label(p_command: BattleCommand = null) -> void:
	if not _command_label.is_node_ready():
		return

	_command_label.text = "Current Command: "
	if p_command:
		_command_label.text += p_command.command_name
	else:
		_command_label.text += "None"

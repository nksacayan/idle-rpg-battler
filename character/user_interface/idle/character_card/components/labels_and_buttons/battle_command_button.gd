extends Button
class_name BattleCommandButton

signal command_selected(p_command: BattleCommand)

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_set_button_text()

func _ready() -> void:
	_set_button_text()

func _set_button_text() -> void:
	if battle_command and is_node_ready():
		text = str(battle_command.command_name)

func _select_command() -> void:
	if not battle_command:
		push_error("BattleCommandButton emitted without command")
	command_selected.emit(battle_command)

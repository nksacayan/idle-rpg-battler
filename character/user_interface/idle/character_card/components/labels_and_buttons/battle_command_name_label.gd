extends Label
class_name BattleCommandNameLabel

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if not is_node_ready():
		return
	
	if not battle_command:
		text = "No Command"
		return
	
	text = battle_command.command_name

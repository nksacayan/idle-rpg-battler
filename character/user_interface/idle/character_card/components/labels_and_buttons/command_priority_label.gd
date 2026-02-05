extends Label
class_name CommandPriorityLabel
# TODO: DRY with other command lables
# HAHAHAHA MORE DRY MORE REFACTOR HAHAHAHAHAH

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if not is_node_ready():
		return

	text = "Priority: "

	if not battle_command:
		text += "NULL"
	else:
		text += BattleCommand.SPEED_PRIORITY.find_key(battle_command.speed_priority)

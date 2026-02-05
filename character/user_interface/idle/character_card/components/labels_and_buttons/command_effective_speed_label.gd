extends Label
class_name CommandEffectiveSpeedLabel
# TODO: DRY out with similar components

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if not is_node_ready():
		return
	
	text = "Effective Speed: "
	if battle_command:
		text += str(battle_command.effective_speed)
	else:
		text += "NULL"
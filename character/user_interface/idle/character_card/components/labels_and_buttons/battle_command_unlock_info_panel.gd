extends PanelContainer
class_name BattleCommandUnlockInfoPanel


@onready var unlock_name_label := %UnlockName as Label
@onready var requirement_label := %RequirementLabel as Label

var battle_command_unlock: CommandUnlock:
	set(p_command_unlock):
		battle_command_unlock = p_command_unlock
		_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if not is_node_ready():
		return

	if battle_command_unlock:
		# What do i even want to display here lmao
		unlock_name_label.text = battle_command_unlock.unlock_name
		# TODO: Refactor to iterate through requirements and make an implemented label
		if battle_command_unlock.requirements.size() > 0:
			requirement_label.text = battle_command_unlock.requirements[0].requirement_name
	else:
		unlock_name_label.text = "No Unlock Selected"
		requirement_label.text = ""
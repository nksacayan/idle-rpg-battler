extends Container
class_name BattleCommandContainer

signal command_selected(p_command: BattleCommand)

var _battle_command_buttons: Array[Button]
@export var command_button_template: PackedScene

func setup(p_battle_commands: Array[BattleCommand]) -> void:
	for button: Button in _battle_command_buttons:
		button.queue_free()
	_battle_command_buttons.clear()

	for command: BattleCommand in p_battle_commands:
		var command_button: Button = command_button_template.instantiate()
		command_button.text = command.command_name
		command_button.pressed.connect(command_selected.emit.bind(command))
		add_child(command_button)
		_battle_command_buttons.append(command_button)

func clear() -> void:
	setup([])
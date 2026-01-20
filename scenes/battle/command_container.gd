extends Container
class_name BattleCommandContainer


signal command_selected(p_command: BattleCommand)

@export var command_button_scene: PackedScene

func setup(p_battle_commands: Array[BattleCommand]) -> void:
	for command: BattleCommand in p_battle_commands:
		_create_button(command)

func _create_button(p_command: BattleCommand) -> void:
	var instance = command_button_scene.instantiate()
	var new_button = instance as BattleCommandButton
	
	if new_button:
		# Set the data BEFORE adding to child to ensure _ready() 
		# in the label has the data it needs.
		new_button.battle_command = p_command
		new_button.command_selected.connect(command_selected.emit)
		add_child(new_button)
	else:
		# Safety: If it's not the right type, free it so we don't leak memory
		instance.queue_free()
		push_error("BattleCommandContainer: PackedScene is not a BaseStatLabel!")

func _clear_children() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

func clear() -> void:
	setup([])
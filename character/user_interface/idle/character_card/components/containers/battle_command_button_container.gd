extends Container
class_name BattleCommandButtonContainer


signal command_selected(p_command: BattleCommand)

@export var command_button_scene: PackedScene

# TODO: This list does not react to a command 
#  being added while the component is alive
var battle_commands: Array[BattleCommand]:
	set(p_commands):
		battle_commands = p_commands
		_update_ui()

func _ready() -> void:
	_update_ui()

func _update_ui() -> void:
	if not is_node_ready():
		return
	_clear_children()

	for command: BattleCommand in battle_commands:
		_create_button(command)	

func _create_button(p_command: BattleCommand) -> void:
	var instance = command_button_scene.instantiate()
	var new_button = instance as BattleCommandButton
	
	if new_button:
		# Set the data BEFORE adding to child to ensure _ready() 
		# in the label has the data it needs.
		new_button.battle_command = p_command
		new_button.command_selected.connect(_on_button_selected)
		add_child(new_button)
	else:
		# Safety: If it's not the right type, free it so we don't leak memory
		instance.queue_free()
		push_error("BattleCommandButtonContainer: PackedScene is not a BaseStatLabel!")

func _clear_children() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()

func _on_button_selected(p_command: BattleCommand) -> void:
	command_selected.emit(p_command)
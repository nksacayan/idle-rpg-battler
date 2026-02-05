extends Container
class_name CommandListContainer

@export var command_card_scene: PackedScene

var command_list: BattleCommandList:
	set(p_command_list):
		if command_list and command_list.command_list_modified.is_connected(_create_command_cards):
			command_list.command_list_modified.disconnect(_create_command_cards)
		command_list = p_command_list
		if command_list:
			command_list.command_list_modified.connect(_create_command_cards)
		_create_command_cards()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_command_cards()

func _create_command_cards() -> void:
	_clear_command_cards()
	if not command_list:
		return
	for command in command_list.commands_view:
		var command_card: BattleCommandQueueCard = command_card_scene.instantiate()
		command_card.battle_command = command
		add_child(command_card)

func _clear_command_cards() -> void:
	for child in get_children():
		remove_child(child)
		child.queue_free()
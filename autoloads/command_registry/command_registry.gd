extends Node
class_name CommandRegistry

@export var command_collection: CommandCollection
@export var default_attack: BattleCommand

# key off of names for now, might need to change this down the road to be more unique
var _command_cache: Dictionary[String, BattleCommand]

func _ready() -> void:
	_init_cache()
	_verify_defaults_in_cache()

func _init_cache() -> void:
	for command in command_collection.commands:
		_command_cache[command.command_name] = command

func _verify_defaults_in_cache() -> void:
	var default_commands: Array[BattleCommand] = [default_attack]
	for command in default_commands:
		if command.command_name not in _command_cache:
			push_warning("Command", command.command_name, "does not exist in master collection")

func find_command_by_name(p_command_name: String) -> BattleCommand:
	if not p_command_name in _command_cache:
			push_error("CommandRegistry: Attempted to find non-existent command: ", p_command_name)
			return null
	
	return _command_cache[p_command_name]
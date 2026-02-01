extends RefCounted
class_name BattleCommandList

signal command_list_modified

var _fast_commands: Array[BattleCommand]
var _normal_commands: Array[BattleCommand]
var _slow_commands: Array[BattleCommand]
var commands_view: Array[BattleCommand]:
	get:
		# This is a new array everytime so UI might be less performant than i'd like
		var combined_commands = _fast_commands + _normal_commands + _slow_commands
		combined_commands.make_read_only()
		return combined_commands

# Should only ever have one command per character
# Don't add commands without a source
# Needs to insert the command in order by speed
func add_command(p_command: BattleCommand) -> void:
	if not p_command.source_character:
		push_warning("Tried to push command without source")
		return
	if has_command_by_character(p_command.source_character):
		remove_command_by_character(p_command.source_character)
	
	var command_priority_list: Array[BattleCommand] = get_priority_array(p_command.speed_priority)
	# find speed index to insert at
	var insert_idx = command_priority_list.size() # Default to the end
	
	# for i in range(_normal_commands.size()):
	# 	if p_command.source_character < speed_array[i].speed:
	# 		insert_idx = i
	# 		break
	_normal_commands.append(p_command)
	command_list_modified.emit()

func remove_command_by_character(p_battle_character: BattleCharacter) -> void:
	var found_index: int = _normal_commands.find_custom(
		func(p_command: BattleCommand): return p_command.source_character == p_battle_character
	)
	if found_index != -1:
		var command_to_remove: BattleCommand = _normal_commands[found_index]
		_normal_commands.remove_at(found_index)
		command_list_modified.emit()

func get_priority_array(p_priority: BattleCommand.SPEED_PRIORITY) -> Array[BattleCommand]:
	match p_priority:
		BattleCommand.SPEED_PRIORITY.FAST:
			return _fast_commands
		BattleCommand.SPEED_PRIORITY.NORMAL:
			return _normal_commands
		BattleCommand.SPEED_PRIORITY.SLOW:
			return _slow_commands
		_:
			push_error("Battle command in list does not have priority")
			return []

func clear() -> void:
	_normal_commands.clear()
	command_list_modified.emit()

func has_command_by_character(p_battle_character: BattleCharacter) -> bool:
	return _normal_commands.any(func(p_command): return p_command.source_character == p_battle_character)

func is_complete_and_valid(_p_battle_characters: Array[BattleCharacter]) -> bool:
	if _normal_commands.any(func(p_command): return not p_command.is_valid()):
		push_warning("A command was invalid")
		return false
	# Temporarily disabling until enemies are implemented
	# if _normal_commands.size() != p_battle_characters.size():
	#     push_warning("Did not have a command per character")
	#     return false
	return true

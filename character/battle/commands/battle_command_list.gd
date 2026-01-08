extends RefCounted
class_name BattleCommandList

signal command_list_modified

var _commands: Array[BattleCommand]
var commands_view: Array[BattleCommand]:
    # This does not enforce real readonly pls dont fuck with
    get: return _commands

# Should only ever have one command per character
# Don't add commands without a source
func add_command(p_command: BattleCommand) -> void:
    if not is_instance_valid(p_command.source_character):
        push_warning("Tried to push command without source")
        return
    if has_command_by_character(p_command.source_character):
        remove_command_by_character(p_command.source_character)
    _commands.append(p_command)
    command_list_modified.emit()

func remove_command_by_character(p_battle_character: BattleCharacter) -> void:
    var found_index: int = _commands.find_custom(
        func(p_command: BattleCommand): return p_command.source_character == p_battle_character
    )
    if found_index != -1:
        _commands.remove_at(found_index)
        command_list_modified.emit()

func clear() -> void:
    _commands.clear()
    command_list_modified.emit()

func has_command_by_character(p_battle_character: BattleCharacter) -> bool:
    return _commands.any(func(p_command): return p_command.source_character == p_battle_character)

func is_complete_and_valid(_p_battle_characters: Array[BattleCharacter]) -> bool:
    if _commands.any(func(p_command): return not p_command.is_valid()):
        push_warning("A command was invalid")
        return false
    # Temporarily disabling until enemies are implemented
    # if _commands.size() != p_battle_characters.size():
    #     push_warning("Did not have a command per character")
    #     return false
    return true
extends RefCounted

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
    pass

func remove_command_by_character(p_battle_character: BattleCharacter) -> void:
    var found_index: int = _commands.find_custom(
        func(p_command: BattleCommand): return p_command.source_character == p_battle_character
    )
    if found_index != -1:
        _commands.remove_at(found_index)

func clear() -> void:
    _commands.clear()

func has_character_command(p_battle_character: BattleCharacter) -> bool:
    return _commands.any(func(p_command): return p_command.source_character == p_battle_character)

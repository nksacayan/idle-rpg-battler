extends RefCounted

var _commands: Array[BattleCommand]

# Should only ever have one command per character
# Don't add commands without a source
func add_command(p_command: BattleCommand) -> void:
    if not is_instance_valid(p_command.source_character):
        push_warning("Tried to push command without source")
        return
    pass

func clear() -> void:
    _commands.clear()

func has_character_command(p_battle_character: BattleCharacter) -> bool:
    return _commands.any(func(p_command): return p_command.source_character == p_battle_character)

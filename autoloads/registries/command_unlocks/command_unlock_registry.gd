extends Node
class_name CommandUnlockRegistry
# TODO: Think about abstracting the registry pattern

@export var unlocks: CommandUnlockCollection

# key off of names for now, might need to change this down the road to be more unique
var _cache: Dictionary[String, CommandUnlock]

func _ready() -> void:
	_init_cache()

func _init_cache() -> void:
	for unlock in unlocks.command_unlocks:
		_cache[unlock.unlock_name] = unlock

func find_by_name(p_unlock_name: String) -> CommandUnlock:
	if not p_unlock_name in _cache:
			push_error("CommandUnlockRegistry: Attempted to find non-existent command: ", p_unlock_name)
			return null
	
	return _cache[p_unlock_name]
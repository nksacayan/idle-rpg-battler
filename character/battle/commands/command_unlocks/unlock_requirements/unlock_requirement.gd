@abstract
extends Resource
class_name CommandUnlockRequirement

@export var requirement_name: String

# TODO: passing character for now but may need a context object later
@abstract func is_satisfied(p_character: CharacterData) -> bool
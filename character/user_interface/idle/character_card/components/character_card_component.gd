@abstract
extends Control
class_name CharacterCardComponent

var character: CharacterData:
	set = _set_character
# make sure to force these to a value if a component can't provide an impl
@export var provide_drop_impl: bool = false
@export var provide_drag_impl: bool = false

# To allow overrides
func _set_character(p_character: CharacterData) -> void:
	character = p_character

# Optional "Interface" methods - defaults do nothing
# If component needs get complex, refactor impl to children of components
# Seems good for now though?
func can_drop_data_impl(_pos: Vector2, _data: Variant) -> bool:
	return false

func drop_data_impl(_pos: Vector2, _data: Variant) -> void:
	pass

func get_drag_data_impl(_pos: Vector2) -> Variant:
	return null
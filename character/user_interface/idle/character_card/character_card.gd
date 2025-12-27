extends PanelContainer
class_name CharacterCard

var character: CharacterOld
@export var character_drag_preview_scene: PackedScene

# drag implementations must be provided by children
# for now only allow 1 implementation. Maybe combo implementations later
var can_drop_data_implementation: Callable:
	set(p_callable):
		if can_drop_data_implementation.is_valid():
			push_error("can_drop_data_implementation already exists")
			return
		can_drop_data_implementation = p_callable

var drop_data_implementation: Callable:
	set(p_callable):
		if drop_data_implementation.is_valid():
			push_error("drop_data_implementation already exists")
			return
		drop_data_implementation = p_callable

var get_drag_data_implementation: Callable:
	set(p_callable):
		if get_drag_data_implementation.is_valid():
			push_error("get_drag_data_implementation already exists")
		get_drag_data_implementation = p_callable

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if can_drop_data_implementation.is_valid():
		return can_drop_data_implementation.call(at_position, data)
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if drop_data_implementation.is_valid():
		drop_data_implementation.call(at_position, data)

func _get_drag_data(at_position: Vector2) -> Variant:
	if get_drag_data_implementation.is_valid():
		return get_drag_data_implementation.call(at_position)
	var preview_card: CharacterDragPreview = character_drag_preview_scene.instantiate()
	preview_card.label_text = character.character_name
	set_drag_preview(preview_card)
	return character
extends PanelContainer
class_name CharacterCard

var character: Character

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
	# i still don't understand this wrapper but it keeps shit from exploding
	var preview_card: CharacterCard = duplicate()
	var preview_wrapper = CenterContainer.new()

	preview_card.custom_minimum_size = self.size
	preview_wrapper.use_top_left = true
	preview_wrapper.add_child(preview_card)

	set_drag_preview(preview_wrapper)
	return character
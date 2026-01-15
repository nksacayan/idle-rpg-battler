extends PanelContainer
class_name CharacterCard

@export var character_drag_preview_scene: PackedScene

var character: CharacterData:
	set(p_character_data):
		character = p_character_data

static var _base_card_comp_template: CharacterCardComponent

func _ready() -> void:
	if not _base_card_comp_template:
		_base_card_comp_template = CharacterCardComponent.new()
	
	_initialize_components(self)

func _initialize_components(root: Node) -> void:
	for child in root.get_children():
		# 1. Try to treat the child as a CardComponent
		var component := child as CharacterCardComponent
		
		if component:
			_setup_component(component)
		
		# 2. Always recurse to find deeper children (e.g. inside Containers)
		_initialize_components(child)
		
func _setup_component(component: CharacterCardComponent) -> void:
	component.character = self.character
	
	# Compare against the static template instead of creating a new one every time
	if component.provide_drop_impl:
		can_drop_data_impl = component.can_drop_data_impl
		drop_data_impl = component.drop_data_impl
	
	if component.provide_drag_impl:
		get_drag_data_impl = component.get_drag_data_impl

# drag implementations must be provided by children
# for now only allow 1 implementation. Maybe combo implementations later
var can_drop_data_impl: Callable:
	set(p_callable):
		if can_drop_data_impl.is_valid():
			push_error("can_drop_data_impl already exists")
			return
		can_drop_data_impl = p_callable

var drop_data_impl: Callable:
	set(p_callable):
		if drop_data_impl.is_valid():
			push_error("drop_data_impl already exists")
			return
		drop_data_impl = p_callable

var get_drag_data_impl: Callable:
	set(p_callable):
		if get_drag_data_impl.is_valid():
			push_error("get_drag_data_impl already exists")
		get_drag_data_impl = p_callable

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	if can_drop_data_impl.is_valid():
		return can_drop_data_impl.call(at_position, data)
	return false

func _drop_data(at_position: Vector2, data: Variant) -> void:
	if drop_data_impl.is_valid():
		drop_data_impl.call(at_position, data)

func _get_drag_data(at_position: Vector2) -> Variant:
	if get_drag_data_impl.is_valid():
		return get_drag_data_impl.call(at_position)
	var preview_card: CharacterDragPreview = character_drag_preview_scene.instantiate()
	preview_card.label_text = character.character_name
	set_drag_preview(preview_card)
	return character
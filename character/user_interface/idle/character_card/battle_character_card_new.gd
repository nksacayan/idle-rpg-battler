extends Control
class_name BattleCharacterCardNew

@export var character_drag_preview_scene: PackedScene
@export var draggable: bool

# Character data should always point to the copy in battle character
#  so that they don't accidentally diverge
# Component can be initialized with either character data,
#  which will create a battle character,
#  or a battle character which will point to the inner character
var character_data: CharacterData:
	get = get_character_data,
	set = set_character_data

# TODO: Might have lifecycle problems in out propogation??
func get_character_data() -> CharacterData:
	return _battle_character.character_data

func set_character_data(p_character_data: CharacterData):
	_battle_character = BattleCharacter.new(p_character_data)
	_initialize_components(self)

var _battle_character: BattleCharacter
var battle_character: BattleCharacter:
	get = get_battle_character,
	set = set_battle_character

func get_battle_character() -> BattleCharacter:
	return _battle_character

func set_battle_character(p_battle_character: BattleCharacter):
	_battle_character = p_battle_character
	_initialize_components(self)

func _ready() -> void:
	_initialize_components(self)

func _initialize_components(root: Node) -> void:
	if not character_data or not _battle_character or not is_node_ready():
		return
	
	for child in root.get_children():
		var component := child
		
		if component is CharacterCardComponent:
			_setup_character_card_component(component)
		elif component is BattleCharacterCardComponent:
			_setup_battle_character_card_component(component)
		
		# Always recurse to find deeper children (e.g. inside Containers)
		_initialize_components(child)
		
func _setup_character_card_component(p_card_component: CharacterCardComponent) -> void:
	p_card_component.character = self.character_data
	
	# Compare against the static template instead of creating a new one every time
	if p_card_component.provide_drop_impl:
		can_drop_data_impl = p_card_component.can_drop_data_impl
		drop_data_impl = p_card_component.drop_data_impl
	
	if p_card_component.provide_drag_impl:
		get_drag_data_impl = p_card_component.get_drag_data_impl

func _setup_battle_character_card_component(p_card_component: BattleCharacterCardComponent) -> void:
	p_card_component.character = self.battle_character
	
	# Compare against the static template instead of creating a new one every time
	if p_card_component.provide_drop_impl:
		can_drop_data_impl = p_card_component.can_drop_data_impl
		drop_data_impl = p_card_component.drop_data_impl
	
	if p_card_component.provide_drag_impl:
		get_drag_data_impl = p_card_component.get_drag_data_impl

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
	if not draggable:
		return null
	var preview_card: CharacterDragPreview = character_drag_preview_scene.instantiate()
	preview_card.label_text = character_data.character_name
	set_drag_preview(preview_card)
	return character_data
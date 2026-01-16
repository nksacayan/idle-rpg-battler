extends BattleCharacterCardComponent

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_initialize_components(self)

func _ready() -> void:
	_initialize_components(self)

func _initialize_components(root: Node) -> void:
	if not character or not is_node_ready():
		return

	for child in root.get_children():
		# Can i refactor this to be more abstract?
		var component := child as BaseStatLabelContainer
		
		if component:
			_setup_component(component)
		
		# 2. Always recurse to find deeper children (e.g. inside Containers)
		_initialize_components(child)
		
func _setup_component(component: BaseStatLabelContainer) -> void:
	component.base_stats = _get_base_stats()

func _get_base_stats() -> Array[BaseStat]:
	var provided_stats: Array[BaseStat]
	provided_stats.assign(character.battle_stats.values())
	return provided_stats
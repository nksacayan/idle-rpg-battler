extends BattleCharacterCardComponent

@export var provided_stat: BattleCharacter.BATTLE_STAT_NAMES

func _enter_tree() -> void:
	provide_drag_impl = false
	provide_drop_impl = false

func _initialize_components(root: Node) -> void:
	if not character or not is_node_ready():
		return

	for child in root.get_children():
		# Can i refactor this to be more abstract?
		var component := child as BaseStatLabel
		
		if component:
			_setup_component(component)
		
		# 2. Always recurse to find deeper children (e.g. inside Containers)
		_initialize_components(child)
		
func _setup_component(component: BaseStatLabel) -> void:
	component.base_stat = character.battle_stats[provided_stat]

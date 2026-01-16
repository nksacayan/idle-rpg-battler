extends BattleCharacterCardComponent

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)

# func _initialize_components(root: Node) -> void:
# 	if not character or not is_node_ready():
# 		return

# 	for child in root.get_children():
# 		# 1. Try to treat the child as a CardComponent
# 		var component := child as BattleCharacterCardComponent
		
# 		if component:
# 			_setup_component(component)
		
# 		# 2. Always recurse to find deeper children (e.g. inside Containers)
# 		_initialize_components(child)
		
# func _setup_component(component: BattleCharacterCardComponent) -> void:
# 	component.character = battle_character

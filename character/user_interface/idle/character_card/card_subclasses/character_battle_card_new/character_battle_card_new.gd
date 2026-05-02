extends BattleCharacterCardNew
class_name SelectableBattleCharacterCard

signal character_selected(p_battle_character: BattleCharacter)

func _ready() -> void:
	super._ready()
	_update_dead_state()

func set_battle_character(p_battle_character: BattleCharacter) -> void:
	super.set_battle_character(p_battle_character)
	_update_dead_state()

func _on_character_selected() -> void:
	character_selected.emit(battle_character)

func _update_dead_state() -> void:
	var button: Button = get_node("VBoxContainer/SelectCharacterButton")
	if not button:
		return
	
	if battle_character and battle_character.is_dead():
		# Disable the button and grey out the card
		button.disabled = true
		self_modulate = Color(0.5, 0.5, 0.5, 1.0)  # Grey out
	else:
		# Enable the button and restore normal appearance
		button.disabled = false
		self_modulate = Color.WHITE
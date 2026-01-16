extends CharacterCardComponent

@onready var name_label: Label = %NameLabel

func _enter_tree() -> void:
	provide_drag_impl = false
	provide_drop_impl = false

func _ready() -> void:
	_refresh_label()

func _set_character(p_character: CharacterData) -> void:
	super (p_character)
	_refresh_label()

func _refresh_label() -> void:
	if is_node_ready() and character:
		name_label.text = str("Name: ", character.character_name)

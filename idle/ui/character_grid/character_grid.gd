extends PanelContainer

signal create_new_character_signal(character_name: String)

@export var character_card_scene: PackedScene
@export var character_name_edit: LineEdit
@export var grid_container: GridContainer

@export_category("testing")
@export var characters: Array[Character]

func new_character_button_pressed():
	create_new_character_signal.emit(character_name_edit.text)
	character_name_edit.clear()

func add_character_to_grid(p_character: Character) -> void:
	var character_card: CharacterCard = character_card_scene.instantiate()
	character_card.character = p_character
	grid_container.add_child(character_card)
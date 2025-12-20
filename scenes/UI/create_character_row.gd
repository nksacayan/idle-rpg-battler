extends HBoxContainer

@export var character_name_line: LineEdit

func call_create_character() -> void:
	CharacterManagerAutoload.create_character(character_name_line.text)

func _on_button_pressed() -> void:
	call_create_character()
	character_name_line.clear()

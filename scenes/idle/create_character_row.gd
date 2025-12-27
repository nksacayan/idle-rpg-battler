extends HBoxContainer

@export var character_name_line: LineEdit

func call_create_character() -> void:
	CharacterManagerAutoload.create_character(character_name_line.text)
	character_name_line.clear()

func _on_button_pressed() -> void:
	call_create_character()

func _on_line_edit_text_submitted(_new_text: String) -> void:
	call_create_character()

extends HBoxContainer

@export var character_name_line: LineEdit

func call_create_character() -> void:
	CharacterManagerAutoload.create_character(character_name_line.text)

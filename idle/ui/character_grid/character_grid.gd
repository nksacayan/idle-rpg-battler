extends PanelContainer

signal create_new_character_signal(character_name: String)

@export var character_name_edit: LineEdit

func new_character_button_pressed():
	create_new_character_signal.emit(character_name_edit.text)
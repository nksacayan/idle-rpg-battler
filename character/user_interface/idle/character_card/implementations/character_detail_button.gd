extends CharacterCardComponent

func _enter_tree() -> void:
	provide_drag_impl = false
	provide_drop_impl = false

func _request_display_character_detail() -> void:
	EventBusAutoload.request_show_character_details.emit(character)
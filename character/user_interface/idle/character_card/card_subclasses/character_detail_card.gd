extends CharacterCard

signal close_details_requested()

func _close_details() -> void:
	close_details_requested.emit()
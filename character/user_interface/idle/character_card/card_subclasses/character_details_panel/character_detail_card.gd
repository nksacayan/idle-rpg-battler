extends CharacterCard

# TODO: Maybe refactor this to a battle character card but it works for now
signal close_details_requested()

func _close_details() -> void:
	close_details_requested.emit()

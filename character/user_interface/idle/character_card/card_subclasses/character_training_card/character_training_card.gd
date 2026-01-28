extends CharacterCard
class_name CharacterTrainingCard

signal character_details_requested(p_character_details: CharacterData)

func _request_character_details() -> void:
	character_details_requested.emit(character)
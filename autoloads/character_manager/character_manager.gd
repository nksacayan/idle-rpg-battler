extends Node
class_name CharacterManager

signal character_created(p_character: CharacterOld)
signal added_to_battle_team(p_character: CharacterOld)
signal removed_from_battle_team(p_character: CharacterOld)

@export var characters: Array[CharacterOld]
@export var battle_team: Array[CharacterOld]
const BATTLE_TEAM_MAX_SIZE = 4

func create_character(p_character_name: String = "") -> void:
	var new_character: CharacterOld
	if p_character_name.is_empty():
		new_character = CharacterOld.new()
		characters.append(new_character)
	else:
		new_character = CharacterOld.new(p_character_name)
		characters.append(new_character)
	character_created.emit(new_character)

func add_to_battle_team(p_character: CharacterOld) -> void:
	if battle_team.size() < BATTLE_TEAM_MAX_SIZE and not battle_team.has(p_character):
		battle_team.append(p_character)
		added_to_battle_team.emit(p_character)

func remove_from_battle_team(p_character: CharacterOld) -> void:
	if battle_team.has(p_character):
		battle_team.erase(p_character)
		removed_from_battle_team.emit(p_character)

extends Node
class_name CharacterManager

signal character_created(p_character: Character)
signal added_to_battle_team(p_character: Character)
signal removed_from_battle_team(p_character: Character)

var characters: Array[Character]
var battle_team: Array[Character]
const BATTLE_TEAM_MAX_SIZE = 4

func create_character(p_character_name: String = "") -> void:
	var new_character: Character
	if p_character_name.is_empty():
		new_character = Character.new()
		characters.append(new_character)
	else:
		new_character = Character.new(p_character_name)
		characters.append(new_character)
	character_created.emit(new_character)

func add_to_battle_team(p_character: Character) -> void:
	if battle_team.size() < BATTLE_TEAM_MAX_SIZE and not battle_team.has(p_character):
		battle_team.append(p_character)
		added_to_battle_team.emit(p_character)

func remove_from_battle_team(p_character: Character) -> void:
	if battle_team.has(p_character):
		battle_team.erase(p_character)
		removed_from_battle_team.emit(p_character)

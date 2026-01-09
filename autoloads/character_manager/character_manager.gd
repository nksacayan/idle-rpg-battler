extends Node
class_name CharacterManager

signal character_created(p_character: CharacterData)
signal added_to_battle_team(p_character: CharacterData)
signal removed_from_battle_team(p_character: CharacterData)

# recommended to refactor characters to a resource and have an autoload node wrapper
@export var characters: Array[CharacterData]
# there was a thought to remove battle team and keep that state local to the idle scene and pass it
#  during scene transition, but shits so cheap just keep it
@export var battle_team: Array[CharacterData]
const BATTLE_TEAM_MAX_SIZE = 4

func create_character(p_character_name: String = "") -> void:
	var new_character: CharacterData
	if p_character_name.is_empty():
		new_character = CharacterData.new()
		characters.append(new_character)
	else:
		new_character = CharacterData.new(p_character_name)
		characters.append(new_character)
	character_created.emit(new_character)

func add_to_battle_team(p_character: CharacterData) -> void:
	if battle_team.size() < BATTLE_TEAM_MAX_SIZE and not battle_team.has(p_character):
		battle_team.append(p_character)
		added_to_battle_team.emit(p_character)

func remove_from_battle_team(p_character: CharacterData) -> void:
	if battle_team.has(p_character):
		battle_team.erase(p_character)
		removed_from_battle_team.emit(p_character)

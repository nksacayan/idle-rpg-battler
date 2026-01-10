extends Node
class_name CharacterManager

signal character_created(p_character: CharacterData)
signal added_to_battle_team(p_character: CharacterData)
signal removed_from_battle_team(p_character: CharacterData)

const BATTLE_TEAM_MAX_SIZE = 4
# recommended to refactor characters to a resource and have an autoload node wrapper
# will probably need to change things anyways once i try saving and loading
@export var characters: Array[CharacterData]
# there was a thought to remove battle team and keep that state local to the idle scene and pass it
#  during scene transition, but shits so cheap just keep it
@export var ally_battle_team_data: Array[CharacterData]
var ally_battle_team: Array[BattleCharacter]:
	get: return _get_battle_team(ally_battle_team_data)
@export var enemy_battle_team_data: Array[CharacterData]
var enemy_battle_team: Array[BattleCharacter]:
	get: return _get_battle_team(enemy_battle_team_data)

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
	if ally_battle_team_data.size() < BATTLE_TEAM_MAX_SIZE \
		and not ally_battle_team_data.has(p_character):
		ally_battle_team_data.append(p_character)
		added_to_battle_team.emit(p_character)
		# TODO: task management when character enters battle team needs further
		#  impl. Want to lockout tasks while a character is on the team
		#  maybe move him between lists so that the reference doesnt exist in the main list?
		CharacterTaskManagerAutoload.delete_character_task_by_character(p_character)

func remove_from_battle_team(p_character: CharacterData) -> void:
	if ally_battle_team_data.has(p_character):
		ally_battle_team_data.erase(p_character)
		removed_from_battle_team.emit(p_character)

static func _get_battle_team(p_battle_team_data: Array[CharacterData]) -> Array[BattleCharacter]:
	var converted_battle_team: Array[BattleCharacter]
	converted_battle_team.assign(
		p_battle_team_data.map(
			func(p_character_data) -> BattleCharacter: \
				return BattleCharacter.new(p_character_data)
		)
	)
	return converted_battle_team

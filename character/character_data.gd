@tool
# Testing using tool to help resource init in editor
extends Resource
class_name CharacterData

enum STAT_NAMES {
	STRENGTH,
	DEXTERITY,
	CONSTITUTION,
	WISDOM,
	INTELLIGENCE,
	CHARISMA
}

const DEFAULT_NAME := "DEFAULT NAME"
@export var character_name: String = DEFAULT_NAME
@export var stats: Dictionary[STAT_NAMES, LeveledStat]

func _init(p_character_name: String = DEFAULT_NAME) -> void:
	character_name = p_character_name
	if stats.is_empty():
		stats = {
			STAT_NAMES.STRENGTH: LeveledStat.new(),
			STAT_NAMES.DEXTERITY: LeveledStat.new(),
			STAT_NAMES.CONSTITUTION: LeveledStat.new(),
			STAT_NAMES.WISDOM: LeveledStat.new(),
			STAT_NAMES.INTELLIGENCE: LeveledStat.new(),
			STAT_NAMES.CHARISMA: LeveledStat.new()
		}

# test commands here
# command brainstorming
# basic attack command?
func basic_attack(p_source_character: BattleCharacter, p_target_character: BattleCharacter) -> void:
	p_target_character.depletable_stats[BattleCharacter.DEPLETABLE_STAT_NAMES.HEALTH].current -= \
		p_source_character.stats[STAT_NAMES.STRENGTH].stat_value.value
# could easily make this take an array of targets for an area attack.
# would i still need to make those seperate commands? or would i just somehow control what args the are allowed to pass?
# oh man how tf would targeting phase work? would need to know allowed parameters
# google AI did have a good idea. Targeting phase issues will be worked out by having an object/system
#  that can take in the command then parse what's valid/invalid
#  still need to have those defined in the command tho

# types of commands:
# attacks
# heals
# buffs
# debuffs
# not a type of command but support conditions (this sounds like buffs debuffs still)
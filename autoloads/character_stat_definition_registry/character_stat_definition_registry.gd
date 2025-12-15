extends Node
class_name CharacterStatDefinitionRegistry

# Hardcoded definitions for simplicity. Use for this project only
@export var _strength_definition: CharacterStatDefinition
var strength_definition: CharacterStatDefinition:
	get: return _strength_definition

@export var _dexterity_definition: CharacterStatDefinition
var dexterity_definition: CharacterStatDefinition:
	get: return _dexterity_definition

@export var _constitution_definition: CharacterStatDefinition
var constitution_definition: CharacterStatDefinition:
	get: return _constitution_definition

@export var _intelligence_definition: CharacterStatDefinition
var intelligence_definition: CharacterStatDefinition:
	get: return _intelligence_definition

@export var _wisdom_definition: CharacterStatDefinition
var wisdom_definition: CharacterStatDefinition:
	get: return _wisdom_definition

@export var _charisma_definition: CharacterStatDefinition
var charisma_definition: CharacterStatDefinition:
	get: return _charisma_definition

var _definitions: Array[CharacterStatDefinition]
var definitions: Array[CharacterStatDefinition]:
	get: return _definitions.duplicate()

func _ready() -> void:
	_definitions = [
		strength_definition,
		dexterity_definition,
		constitution_definition,
		intelligence_definition,
		wisdom_definition,
		charisma_definition
	]
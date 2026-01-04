extends Resource
class_name BattleCommand

enum TARGET_TYPE {
    ALLY,
    ENEMY,
    SELF
}

# Make params arrays but expect to have some size 1
@export var command_name: String
@export var command_description: String
@export var target_types: Array[TARGET_TYPE]
@export var max_targets: int = 1
@export var effects: Array[BattleEffect]
var targets: Array[BattleCharacter]
var source_character: BattleCharacter

func execute() -> void:
    for effect: BattleEffect in effects:
        effect.apply_effect(source_character, targets)
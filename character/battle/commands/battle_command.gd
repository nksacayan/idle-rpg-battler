extends Resource
class_name BattleCommand

enum TARGET_TYPE {
	ALLY,
	ENEMY,
	SELF
}

enum SPEED_PRIORITY {
	SLOW,
	NORMAL,
	FAST
}

# Make params arrays but expect to have some size 1
@export var command_name: String
@export var command_description: String
@export var target_types: Array[TARGET_TYPE]
@export var min_targets: int = 1
@export var max_targets: int = 1
@export var effects: Array[BattleEffect]
@export var speed_bonus: int = 0
@export var speed_priority: SPEED_PRIORITY = SPEED_PRIORITY.NORMAL
var targets: Array[BattleCharacter]
var source_character: BattleCharacter
var effective_speed: int:
	get:
		if not source_character:
			return -1
		return (
			source_character.battle_stats[BattleCharacter.BATTLE_STAT_NAMES.SPEED].value +
			speed_bonus
		)

func execute() -> void:
	if not is_valid():
		push_warning("Tried to execute non-valid command")
		return
	for effect: BattleEffect in effects:
		effect.apply_effect(source_character, targets)

func is_valid() -> bool:
	if targets.size() < min_targets or targets.size() > max_targets:
		push_warning("Does not have max targets")
		return false
	if not source_character:
		push_error("Source character not valid")
		return false
	return true

extends Resource
class_name TaskDefinition

@export var task_name: String
@export var related_stat: CharacterStatDefinition
@export var exp_reward: int
@export var max_progress: float = 100.0
const MIN_PROGRESS: float = 0.0
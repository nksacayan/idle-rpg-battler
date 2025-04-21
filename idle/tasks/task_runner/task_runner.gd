extends Node

var characters_and_tasks: Dictionary[Character, Task]

func _process(delta: float):
	_work_all_character_task_sets(delta)

func _work_all_character_task_sets(delta: float):
	for character: Character in characters_and_tasks:
			var task: Task = characters_and_tasks[character]
			for stat: CharacterStats.StatNames in task.stats_and_exp:
				character.character_stats.base_stats[stat].stat_value += round(task.stats_and_exp[stat] * delta)
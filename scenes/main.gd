extends Node

# Manage main scenes by add/removing them from scene tree

@export var idle_main_packed: PackedScene
@export var battle_main_packed: PackedScene
var idle_main: IdleMain
var battle_main: BattleMain

func _ready():
	idle_main = idle_main_packed.instantiate()
	idle_main.begin_battle_requested.connect(switch_to_battle_scene)
	battle_main = battle_main_packed.instantiate()
	battle_main.exit_battle_requested.connect(switch_to_idle_scene)
	switch_to_idle_scene()

func switch_to_battle_scene() -> void:
	var ally_battle_team := CharacterManagerAutoload.ally_battle_team
	var enemy_battle_team := CharacterManagerAutoload.enemy_battle_team
	if ally_battle_team.is_empty() or enemy_battle_team.is_empty():
		push_warning("Tried to start battle with an empty team")
		return
	battle_main.setup(ally_battle_team, enemy_battle_team)
	if idle_main.get_parent() == self:
		remove_child(idle_main)
	if battle_main.get_parent() == self:
		return
	add_child(battle_main)
	battle_main.request_ready() # needs to rerun ready stuff for setup. code smells

func switch_to_idle_scene() -> void:
	if battle_main.get_parent() == self:
		remove_child(battle_main)
	if idle_main.get_parent() == self:
		return
	add_child(idle_main)

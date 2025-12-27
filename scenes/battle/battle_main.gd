extends PanelContainer

signal _player_commands_received

@export var battle_team: Array[CharacterOld]
var commands
# get player commands for each character
# execute commands
# enemy turn (we'll mess with turn order later)

func _ready() -> void:
	_run_main_battle_loop()

func _run_main_battle_loop() -> void:
	while not _is_battle_over():
		print("running battle loop")
		var player_commands_awaited := await _get_player_commands()
		if player_commands_awaited:
			print("true player command")
		else:
			print("false player commands")

func _get_player_commands() -> bool:
	await _player_commands_received
	print("_get_player_commands")
	return true

func _resolve_commands() -> bool:
	print("_resolve_commands")
	return true

func _run_enemy_turn() -> bool:
	print("_run_enemy_turn")
	return true

func _is_battle_over() -> bool:
	return false

func emit_player_commands_recieved() -> void:
	_player_commands_received.emit()
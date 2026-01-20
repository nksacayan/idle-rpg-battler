extends BattleCharacterCardComponent

@onready var battle_command_button_container := \
	%BattleCommandButtonContainer as BattleCommandButtonContainer
@onready var battle_command_detail_panel := \
	%BattleCommandDetailPanel as BattleCommandDetailPanel

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_provide_commands()

func _ready() -> void:
	_provide_commands()

func _provide_commands() -> void:
	if character and is_node_ready():
		battle_command_button_container.battle_commands = character.local_battle_commands

func _display_command(p_command: BattleCommand) -> void:
	battle_command_detail_panel.battle_command = p_command

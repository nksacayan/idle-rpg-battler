extends BattleCharacterCardComponent

@onready var battle_command_button_container := \
	%BattleCommandButtonContainer as BattleCommandButtonContainer
@onready var battle_command_detail_panel := \
	%BattleCommandDetailPanel as BattleCommandDetailPanel

func _set_character(p_character: BattleCharacter) -> void:
	# 1. Safely disconnect from the OLD character if it exists
	if character and character.local_battle_commands_updated.is_connected(_provide_commands):
		character.local_battle_commands_updated.disconnect(_provide_commands)
	
	# 2. Update the reference
	super(p_character) # Assuming 'character' is set here in the base class
	
	# 3. Connect to the NEW character
	if character:
		character.local_battle_commands_updated.connect(_provide_commands)
	
	_provide_commands()

func _ready() -> void:
	_provide_commands()

func _provide_commands() -> void:
	if character and is_node_ready():
		battle_command_button_container.battle_commands = character.local_battle_commands

func _display_command(p_command: BattleCommand) -> void:
	battle_command_detail_panel.battle_command = p_command

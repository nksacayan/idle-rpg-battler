extends BattleCharacterCardComponent
class_name CommandUnlocksDisplayComponent

@onready var battle_command_buttons := %BattleCommandUnlockButtonContainer as BattleCommandButtonContainer
@onready var battle_command_detail := %BattleCommandDetailPanel as BattleCommandDetailPanel
@onready var battle_command_unlock_info := %BattleCommandUnlockInfoPanel as BattleCommandUnlockInfoPanel

var available_unlocks: Array[CommandUnlock]:
	set(p_unlocks):
		available_unlocks = p_unlocks
		_provide_available_unlocks()

var selected_unlock: CommandUnlock:
	set(p_command_unlock):
		pass

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_provide_available_unlocks()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_provide_available_unlocks()

func _provide_available_unlocks() -> void:
	if not is_node_ready():
		return

	if not available_unlocks or not character:
		battle_command_buttons.battle_commands = []
		return

	var filtered_commands: Array[BattleCommand]
	
	filtered_commands.assign(
		available_unlocks.map(func(u): return u.command)
		.filter(func(c): return c not in character.local_battle_commands)
	)
	
	battle_command_buttons.battle_commands = filtered_commands


extends BattleCharacterCardComponent
class_name CommandUnlocksDisplayComponent

# TODO: Refactor and go back to using string types over casting
@onready var battle_command_buttons := %BattleCommandUnlockButtonContainer as BattleCommandButtonContainer
@onready var battle_command_detail := %BattleCommandDetailPanel as BattleCommandDetailPanel
@onready var battle_command_unlock_info := %BattleCommandUnlockInfoPanel as BattleCommandUnlockInfoPanel
@onready var message_label := %MessageLabel as Label

var available_unlocks: Array[CommandUnlock]:
	set(p_unlocks):
		available_unlocks = p_unlocks
		_provide_available_unlocks()

var selected_unlock: CommandUnlock:
	set(p_command_unlock):
		selected_unlock = p_command_unlock
		_provide_selected_unlock()

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_provide_available_unlocks()

func _ready() -> void:
	_provide_available_unlocks()

func _provide_available_unlocks() -> void:
	if not is_node_ready():
		return

	if not available_unlocks or not character:
		battle_command_buttons.battle_commands = []
		return

	var filtered_commands: Array[BattleCommand]
	
	# Resources are compared by reference and these were duplicated so use name as a comparison
	filtered_commands.assign(
		available_unlocks.map(func(unlock): return unlock.command)
		.filter(func(command): return command.command_name not in \
			character.local_battle_commands.map(func(local_command: BattleCommand): 
				return local_command.command_name))
	)
	
	battle_command_buttons.battle_commands = filtered_commands

func _provide_selected_unlock() -> void:
	if selected_unlock:
		battle_command_detail.battle_command = selected_unlock.command
		battle_command_unlock_info.battle_command_unlock = selected_unlock
	else:
		battle_command_detail.battle_command = null
		battle_command_unlock_info.battle_command_unlock = null

func _on_unlockable_command_selected(p_command: BattleCommand) -> void:
	var unlockables_of_command: Array[CommandUnlock]
	unlockables_of_command.assign(available_unlocks.filter(
		func(unlock): return unlock.command == p_command
	))
	if unlockables_of_command.size() <= 0:
		push_error("Somehow selected a command without a matching unlock", p_command)
		selected_unlock = null
		return
	selected_unlock = unlockables_of_command[0]

func _unlock_selected_command() -> void:
	if not selected_unlock:
		message_label.text = "No unlockable selected"
		return

	character.character_data.available_battle_commands.append(selected_unlock.command)
	character.refresh_battle_commands()
	message_label.text = str(selected_unlock.command.command_name, " unlocked")
	selected_unlock = null
	_provide_available_unlocks()

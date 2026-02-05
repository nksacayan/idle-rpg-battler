extends PanelContainer
class_name BattleCommandQueueCard
# TODO: Abstract and dry this out with a card system like character but for commands

@onready var character_name_label_component: CharacterCardComponent = %CharacterNameLabelComponent
@onready var command_name_label: BattleCommandNameLabel = %BattleCommandNameLabel
@onready var command_priority_label: CommandPriorityLabel = %CommandPriorityLabel
@onready var command_effective_speed_label: CommandEffectiveSpeedLabel = %CommandEffectiveSpeedLabel

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_provide_battle_command()
		_provide_command_character()

func _ready():
	_provide_battle_command()
	_provide_command_character()

func _provide_battle_command() -> void:
	if not is_node_ready():
		return
	command_name_label.battle_command = battle_command
	command_priority_label.battle_command = battle_command
	command_effective_speed_label.battle_command = battle_command

func _provide_command_character() -> void:
	if not is_node_ready() or not battle_command.source_character:
		return
	character_name_label_component.character = battle_command.source_character.character_data

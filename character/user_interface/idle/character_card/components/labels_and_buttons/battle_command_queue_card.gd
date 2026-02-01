extends PanelContainer
class_name BattleCommandQueueCard

@onready var battle_character_card: BattleCharacterCardNew = %BattleCharacterCard
@onready var command_name_label: BattleCommandNameLabel = %BattleCommandNameLabel

var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_provide_battle_command()
		_provide_command_character()

func _ready():
	_provide_battle_command()
	_provide_command_character()

func _provide_battle_command() -> void:
	command_name_label.battle_command = battle_command

func _provide_command_character() -> void:
	battle_character_card.battle_character = battle_command.source_character

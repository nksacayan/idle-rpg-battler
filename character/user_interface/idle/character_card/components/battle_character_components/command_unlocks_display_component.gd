extends BattleCharacterCardComponent

var all_unlocks: Array[CommandUnlock]

var selected_unlock: CommandUnlock:
	set(p_command_unlock):
		pass

func _set_character(p_character: BattleCharacter) -> void:
	super (p_character)
	_provide_command_unlocks()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_provide_command_unlocks()

func _fetch_command_unlocks() -> void:
	pass

func _provide_command_unlocks() -> void:
	pass


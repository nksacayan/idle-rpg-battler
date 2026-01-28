extends Control

@onready var command_unlocks_display_component = %CommandUnlocksDisplayComponent as CommandUnlocksDisplayComponent

func _ready() -> void:
	_provide_unlocks()

func _provide_unlocks() -> void:
	if is_node_ready():
		command_unlocks_display_component.available_unlocks = CommandUnlockRegistryAutoload.get_all()
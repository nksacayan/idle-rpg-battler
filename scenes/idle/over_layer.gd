extends CanvasLayer

@onready var character_details_panel := %CharacterDetailsPanel as CharacterCard

func _ready() -> void:
	# EventBusAutoload.request_show_character_details.connect(_show_character_details_panel)
	pass

func _show_character_details_panel(p_character_data: CharacterData) -> void:
	character_details_panel.character = p_character_data
	character_details_panel.show()
	show()

func _close_overlay() -> void:
	for child: CanvasItem in get_children():
		child.hide()
	hide()
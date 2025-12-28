extends PanelContainer
class_name CharacterBattleCard

var character: CharacterData
@onready var name_label: Label = %NameLabel

func _ready() -> void:
	name_label.text = character.character_name
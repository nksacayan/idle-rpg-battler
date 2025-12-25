extends Control
class_name CharacterDragPreview

var preview_label: Label
var label_text: String

func _ready() -> void:
    preview_label = %PreviewNameLabel
    preview_label.text = label_text
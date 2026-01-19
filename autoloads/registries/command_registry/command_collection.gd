extends Resource
class_name CommandCollection

# Using this layer to seperate the resource and the autoload
#  Hopefully helps with loading and stuff?
@export var commands: Array[BattleCommand]
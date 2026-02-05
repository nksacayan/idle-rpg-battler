extends PanelContainer
class_name BattleCommandDetailPanel

@onready var name_label := %CommandNameLabel as Label
@onready var description_label := %CommandDescriptionLabel as Label
@onready var min_targets_label := %MinTargetsLabel as Label
@onready var max_targets_label := %MaxTargetsLabel as Label
@onready var target_types_label := %TargetTypesLabel as Label
@onready var effects_label := %EffectsLabel as Label
@onready var priority_label: CommandPriorityLabel = %CommandPriorityLabel
@onready var speed_bonus_label: CommandSpeedBonusLabel = %CommandSpeedBonusLabel

const MIN_TARGETS_PREFIX := "Min targets: "
const MAX_TARGETS_PREFIX := "Max targets: "
const TARGET_TYPES_PREFIX := "Can target: "
const EFFECT_PREFIX := "Effects: "

#TODO: Description is gonna need a scroll or something
var battle_command: BattleCommand:
	set(p_command):
		battle_command = p_command
		_update_ui()
		_provide_battle_command()

func _ready() -> void:
	_update_ui()

func _provide_battle_command() -> void:
	priority_label.battle_command = battle_command
	speed_bonus_label.battle_command = battle_command

func _update_ui() -> void:
	if not is_node_ready():
		return

	# TODO: If i have multiple places where i need command details these labels can be pulled into components
	if not battle_command:
		name_label.text = ""
		description_label.text = ""
		min_targets_label.text = MIN_TARGETS_PREFIX + ""
		max_targets_label.text = MAX_TARGETS_PREFIX + ""
		target_types_label.text = TARGET_TYPES_PREFIX + ""
		effects_label.text = EFFECT_PREFIX + ""
	else:
		name_label.text = battle_command.command_name
		description_label.text = battle_command.command_description
		min_targets_label.text = MIN_TARGETS_PREFIX + str(battle_command.min_targets)
		max_targets_label.text = MAX_TARGETS_PREFIX + str(battle_command.max_targets)
		target_types_label.text = TARGET_TYPES_PREFIX + ", ".join(battle_command.target_types)

		var effect_names: Array[String]
		effect_names.assign(battle_command.effects.map(
			func(effect: BattleEffect) -> String: return effect.effect_name
		))
		var effects_delimited := ", ".join(effect_names)
		effects_label.text = EFFECT_PREFIX + effects_delimited

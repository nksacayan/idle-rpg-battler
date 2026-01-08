extends Label


func _on_turn_state_changed(p_turn_state: BattleMain.TURN_STATE) -> void:
	text = BattleMain.TURN_STATE.find_key(p_turn_state)
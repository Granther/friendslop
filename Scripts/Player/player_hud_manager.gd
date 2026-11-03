extends PlayerComponent

# Manages HUD and health reactions of player

# Listens
# InterScanner:looking_state_changed -> _set_inter_prompt

func _on_health_damaged() -> void:
	pass 

func _on_health_healed() -> void:
	pass 

func _on_health_died() -> void:
	pass
	#player_died.emit()
	
func _set_interact_prompt(setting: bool) -> void:
	if setting: _show_interact_prompt()
	else: _hide_interact_prompt()

func _show_interact_prompt() -> void:
	pass
	#player_ref.ui._show_crosshair_prompt("E")
	
func _hide_interact_prompt() -> void:
	pass
	#player_ref.ui._hide_crosshair_prompt()

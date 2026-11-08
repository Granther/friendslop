extends PlayerComponent

# Manages HUD and health reactions of player

# Listens
# InterScanner:looking_state_changed -> _set_inter_prompt
# HealthComp:died
# HealthComp:healed
# HealthComp:damaged

func _on_health_damaged(new_health: int) -> void:
	player_ref.ui.player_hud.set_health_lvl(new_health)

func _on_health_healed(new_health: int) -> void:
	player_ref.ui.player_hud.set_health_lvl(new_health)

func _on_health_died() -> void:
	player_ref.ui.player_hud.set_health_lvl(0)
	
func _set_interact_prompt(setting: bool) -> void:
	if setting: _show_interact_prompt()
	else: _hide_interact_prompt()

func _show_interact_prompt() -> void:
	pass
	#player_ref.ui._show_crosshair_prompt("E")
	
func _hide_interact_prompt() -> void:
	pass
	#player_ref.ui._hide_crosshair_prompt()

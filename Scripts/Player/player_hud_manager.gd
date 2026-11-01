extends PlayerComponent

# Manages HUD and health reactions of player

# Outputs
signal player_died # -> MovementManager

func _on_health_damaged() -> void:
	pass 

func _on_health_healed() -> void:
	pass 

func _on_health_died() -> void:
	player_died.emit()

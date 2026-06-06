extends PlayerComponent

# Manages HUD and health reactions of player

# Outputs
signal player_died # -> MovementManager

func _on_health_damaged() -> void:
	pass # Replace with function body.

func _on_health_healed() -> void:
	pass # Replace with function body.

func _on_health_died() -> void:
	player_died.emit()

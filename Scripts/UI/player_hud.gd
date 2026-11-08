extends Control

@onready var health_bar: ProgressBar = $MarginContainer/HealthContainer/VBoxContainer/HealthBar

func _ready() -> void:
	set_health_lvl(100)

func set_health_lvl(health: int):
	health_bar.value = health

extends CanvasLayer

@onready var pause_menu: Control = $PauseMenu
@onready var player_hud: Control = $PlayerHUD

func _ready() -> void:
	add_to_group("game_ui")

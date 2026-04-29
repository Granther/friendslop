extends CanvasLayer

@onready var entry_menu = $EntryMenu
@onready var game_menu = $InGameUI

@onready var crosshair: CrosshairDrawer = $CrosshairDrawer

func _ready():
	crosshair.apply_data(preload("res://Resources/Crosshair/plus.tres"))
	UIHandler.register_ui(self)

func is_menu_open() -> bool:
	return (entry_menu.visible or game_menu.visible)

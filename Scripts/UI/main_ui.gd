extends CanvasLayer

@onready var entry_menu = $EntryMenu
@onready var game_menu = $InGameUI

func _ready():
	UIHandler.register_ui(self)

func is_menu_open() -> bool:
	return (entry_menu.visible or game_menu.visible)

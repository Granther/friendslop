extends CanvasLayer

@onready var entry_menu = $EntryMenu
@onready var game_menu = $InGameUI

func is_menu_open() -> bool:
	return (entry_menu.visible or game_menu.visible)

#@onready var player = get_parent()
#
## Remember, this is called before player calls ready
#func _ready() -> void:
	#set_all_uis(false)
	#set_entry_select_menu(true)
	#player.set_in_ui(true)
	## First thing player sees is entry UI
	##if player.get_is_connected():
		##set_all_uis(false)
		##set_entry_select_menu(true)
		##player.set_in_ui(true)
	##else:
		##set_all_uis(false)
		##player.set_in_ui(false)
#
#func set_game_select_menu(setting: bool):
	#if setting: 
		#game_menu.show()
	#else: 
		#game_menu.hide()
#
#func set_entry_select_menu(setting: bool):
	#if setting: 
		#entry_menu.show()
	#else: 
		#entry_menu.hide()
		#
#func set_all_uis(setting: bool):
	#if setting:
		#entry_menu.show()
		#game_menu.show()
	#else:
		#entry_menu.hide()
		#game_menu.hide()

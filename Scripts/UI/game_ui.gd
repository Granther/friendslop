extends CanvasLayer

# So, as it stands the current UI has too many jobs. It should merely pass things around

@onready var tablist: PanelContainer = $MarginContainer/TabList
@onready var startup_menu: PanelContainer = $MarginContainer/StartupMenu
@onready var pause_menu: PanelContainer = $MarginContainer/PauseMenu

var MENU_STATE: MENU_MODE
enum MENU_MODE { STARTUP, PAUSE, NONE, LOADING }

func _ready():
	add_to_group("game_ui")
	
	startup_menu.show()
	pause_menu.hide()
	tablist.hide()
	
	MENU_STATE = MENU_MODE.STARTUP

func _on_local_btn_pressed() -> void:
	startup_menu.hide()
	MENU_STATE = MENU_MODE.LOADING
	await MultiplayerConnectionHandler.local_multiplayer_a()
	MENU_STATE = MENU_MODE.NONE

func _unhandled_input(event: InputEvent) -> void:
	match(MENU_STATE):
		MENU_MODE.STARTUP:
			pass
		MENU_MODE.NONE:
			if event.is_action_pressed("escape"): _pause()
		MENU_MODE.PAUSE:
			if event.is_action_pressed("escape"): _unpause()

func _pause():
	show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unpause() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func is_ui_open() -> bool:
	print("here")
	# returns true if we are anything but NONE for the state
	return MENU_STATE != MENU_MODE.NONE

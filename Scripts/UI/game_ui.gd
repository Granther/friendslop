extends CanvasLayer

# So, as it stands the current UI has too many jobs. It should merely pass things around

@onready var tablist: PanelContainer = $MarginContainer/TabList
@onready var startup_menu: PanelContainer = $MarginContainer/StartupMenu
@onready var pause_menu: PanelContainer = $MarginContainer/PauseMenu
@onready var room_id_box: LineEdit = $MarginContainer/StartupMenu/MarginContainer/VBoxContainer/RoomID
@onready var loading_prompt: CenterContainer = $MarginContainer/LoadingPrompt
@onready var info_prompt: CenterContainer = $MarginContainer/InfoPrompt
@onready var info_prompt_btn: Button = $MarginContainer/InfoPrompt/PanelContainer/MarginContainer/VBoxContainer/OkBtn
@onready var info_prompt_label: Label = $MarginContainer/InfoPrompt/PanelContainer/MarginContainer/VBoxContainer/Label

@onready var crosshair: CrosshairDrawer = $Crosshair

var MENU_STATE: MENU_MODE
enum MENU_MODE { STARTUP, PAUSED, NONE, LOADING }

func _ready():
	# Allows everything in the scene to access this
	add_to_group("game_ui")
	
	startup_menu.show()
	pause_menu.hide()
	tablist.hide()
	crosshair.hide()
	
	MENU_STATE = MENU_MODE.STARTUP

## Startup Menu ##
func _on_local_btn_pressed() -> void:
	startup_menu.hide()
	MENU_STATE = MENU_MODE.LOADING
	await MultiplayerConnectionHandler.local_multiplayer_a()
	MENU_STATE = MENU_MODE.NONE
	crosshair.show()

# Remote
func _on_join_btn_pressed() -> void:
	var room_id = room_id_box.text.to_upper()
	if room_id == "":
		await _show_info_msg_a("Must enter room ID to play online")
		return
	startup_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_loading()
	await MultiplayerConnectionHandler.remote_multiplayer_join_a(room_id)
	_done_loading()
	crosshair.show()

# Remote
func _on_host_btn_pressed() -> void:
	startup_menu.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	_loading()
	var room_id = await MultiplayerConnectionHandler.remote_multiplayer_host_a()
	_done_loading()
	crosshair.show()
	print("room_id: ", room_id)

## PauseMenu ##
func _on_quit_btn_pressed() -> void:
	multiplayer.peer_disconnected.emit()
	get_tree().quit()

func _on_quit_menu_btn_pressed() -> void:
	pass 

func _on_back_btn_pressed() -> void:
	_unpause()

func _unhandled_input(event: InputEvent) -> void:
	match(MENU_STATE):
		MENU_MODE.STARTUP:
			pass
		MENU_MODE.NONE:
			if event.is_action_pressed("escape"): _pause()
		MENU_MODE.PAUSED:
			if event.is_action_pressed("escape"): _unpause()

func _pause():
	crosshair.hide()
	pause_menu.show()
	MENU_STATE = MENU_MODE.PAUSED
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _unpause():
	crosshair.show()
	pause_menu.hide()
	MENU_STATE = MENU_MODE.NONE
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _loading():
	loading_prompt.show()
	MENU_STATE = MENU_MODE.LOADING

func _done_loading():
	loading_prompt.hide()
	MENU_STATE = MENU_MODE.NONE

# Shows info message that must be dismissed
func _show_info_msg_a(msg: String):
	info_prompt_label.text = msg
	info_prompt.show()
	await info_prompt_btn.button_down
	info_prompt.hide()

func is_menu_open() -> bool:
	# returns true if we are anything but NONE for the state
	return MENU_STATE != MENU_MODE.NONE

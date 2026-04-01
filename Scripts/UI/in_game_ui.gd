extends PanelContainer

@onready var entry_menu = $"../EntryMenu"

func _ready():
	hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("escape") and not entry_menu.visible:
		if visible:
			back_to_game()
		else:
			show()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_quit_menu_btn_pressed() -> void:
	pass

func _on_back_btn_pressed() -> void:
	back_to_game()

func back_to_game() -> void:
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

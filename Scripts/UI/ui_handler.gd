extends Node

var in_ui: bool
var ui_obj: Node

func _ready() -> void:
	print("started ui handler")

func set_ui_mode(setting: bool):
	in_ui = setting

func get_ui() -> Node:
	return ui_obj

func register_ui(ui: Node):
	ui_obj = ui

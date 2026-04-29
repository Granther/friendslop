@tool # runs in editor
extends Control # so, ui
class_name CrosshairDrawer

enum CrosshairType { PLUS, CIRCLE, CROSS}

@export var crosshair_type: CrosshairType = CrosshairType.PLUS: set = _set_and_redraw
@export var color: Color = Color.WHITE: set = _set_and_redraw
@export var line_thickness: float = 2.0: set = _set_and_redraw
@export var base_size: int = 10: set = _set_and_redraw
@export var max_recoil_multiplier: float = 5.0: set = _set_and_redraw
@export var plus_gap: int = 5: set = _set_and_redraw

func _set_and_redraw(v):
	pass

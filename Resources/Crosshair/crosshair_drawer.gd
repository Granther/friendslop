# CrosshairDrawer.gd

# Full transparecny, this was found here: https://gameidea.org/2025/09/07/building-the-hud-dynamic-crosshair-fps-series-part-9

# But, very good, because this makes the crosshair incredibly dynamic, we just load a different resource for every different type of thing we want

extends Control
class_name CrosshairDrawer

enum CrosshairType { PLUS, CIRCLE, CROSS }

@export var crosshair_type: CrosshairType = CrosshairType.PLUS: set = _set_and_redraw
@export var color: Color = Color.WHITE: set = _set_and_redraw
@export var line_thickness: float = 2.0: set = _set_and_redraw
@export var base_size: int = 10: set = _set_and_redraw
@export var max_recoil_multiplier: float = 5.0: set = _set_and_redraw
@export var plus_gap: int = 5: set = _set_and_redraw

@export_range(0.0, 1.0, 0.01) var recoil: float = 0.0:
	set(value):
		recoil = clampf(value, 0.0, 1.0)
		queue_redraw()

func _set_and_redraw(value):
	# Helper to avoid repeating queue_redraw() for every variable.
	queue_redraw()

func _process(delta):
	# Slowly reduce recoil over time for a smooth recovery animation.
	if recoil > 0:
		recoil = move_toward(recoil, 0, delta * 2.0) # Recover in 0.5 seconds

func _draw():
	var center: Vector2 = size / 2.0
	var spread: float = lerp(0.0, float(base_size * max_recoil_multiplier), recoil)
	
	match crosshair_type:
		CrosshairType.PLUS:
			var current_gap = plus_gap + spread
			# Top
			draw_line(center + Vector2(0, -current_gap), center + Vector2(0, -current_gap - base_size), color, line_thickness)
			# Bottom
			draw_line(center + Vector2(0, current_gap), center + Vector2(0, current_gap + base_size), color, line_thickness)
			# Left
			draw_line(center + Vector2(-current_gap, 0), center + Vector2(-current_gap - base_size, 0), color, line_thickness)
			# Right
			draw_line(center + Vector2(current_gap, 0), center + Vector2(current_gap + base_size, 0), color, line_thickness)

## Applies a CrosshairData resource to this node, updating its appearance.
func apply_data(data: CrosshairData):
	if not data:
		visible = false
		return
	
	visible = true
	self.crosshair_type = data.crosshair_type
	self.color = data.color
	self.line_thickness = data.line_thickness
	self.base_size = data.base_size
	self.max_recoil_multiplier = data.max_recoil_multiplier
	self.plus_gap = data.plus_gap

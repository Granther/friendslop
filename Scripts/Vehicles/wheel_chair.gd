extends VehicleBody3D

@export var icomp: InteractComponent
@export var sensitivity: float = 0.003

var MAX_STEER: float = 0.9
var ENGINE_POWER: float = 300

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	icomp.phys_movement_func = _phys_movement

func get_icomp() -> InteractComponent:
	return icomp

func _on_inter():
	pass

var current_turn_speed: float = 0.0

func _phys_movement(delta: float):
	engine_force = Input.get_axis("down", "up") * ENGINE_POWER
	var target_turn = Input.get_axis("right", "left") * 2.0
	current_turn_speed = lerp(current_turn_speed, target_turn, delta * 5.0)
	rotate_y(current_turn_speed * delta)

func _unhandled_input(event: InputEvent) -> void:
	pass

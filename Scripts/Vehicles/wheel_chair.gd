extends VehicleBody3D

@export var icomp: InteractComponent

var MAX_STEER: float = 0.9
var ENGINE_POWER: float = 300

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	icomp.phys_movement_func = _phys_movement
	
func get_icomp() -> InteractComponent:
	return icomp

func _on_inter():
	pass

func _phys_movement(delta: float):
	if icomp.player_on_vehicle():
		steering = move_toward(steering, Input.get_axis("right", "left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("down", "up") * ENGINE_POWER
	else:
		engine_force = 0

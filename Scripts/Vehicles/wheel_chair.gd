extends VehicleBody3D

@export var icomp: InteractComponent

var SPEED: float = 3

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	icomp.phys_movement_func = _phys_movement
	
func get_icomp() -> InteractComponent:
	return icomp

func _on_inter():
	pass

func _phys_movement(delta: float):	
	var input_dir = Input.get_vector("right", "left", "down", "up")
	var move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_direction:
		linear_velocity.x = lerp(linear_velocity.x, move_direction.x * SPEED, delta * 6) 
		linear_velocity.z = lerp(linear_velocity.z, move_direction.z * SPEED, delta * 6) 
		linear_velocity.x = linear_velocity.x/1.2
		linear_velocity.z = linear_velocity.z/1.2

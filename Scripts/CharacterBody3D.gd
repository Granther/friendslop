extends CharacterBody3D


var SPEED = 0
const SPRINT = false
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var BASE_FOV = 90.0
var FOV_CHANGE = 1

@onready var head = $Head
@onready var camera = $Head/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	 
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))


func _physics_process(delta: float) -> void:
	var velocity_clamp = clamp(velocity.length(), SPEED/4.5, SPEED/4.5)
	var target_fov = BASE_FOV * FOV_CHANGE * velocity_clamp
	camera.fov = lerp(camera.fov, target_fov, delta * 4)
	if Input.is_action_pressed("ToggleMouseFocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		SPEED = 5
		FOV_CHANGE = 0.7
	else:
		SPEED = 3
		FOV_CHANGE = 1
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction and is_on_floor():
		
		velocity.x = lerp(velocity.x, direction.x * SPEED, delta * 6) 
		velocity.z = lerp(velocity.z, direction.z * SPEED, delta * 6) 
	else: if is_on_floor():
			velocity.x = velocity.x/1.2
			velocity.z = velocity.z/1.2
	move_and_slide()

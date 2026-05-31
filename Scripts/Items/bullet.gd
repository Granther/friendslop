class_name Bullet extends Area3D

var speed: float
var direction: Vector3
var velocity: Vector3
var lifetime: int = 500 # Amount of FRAMES the bullet is alive before getting culled
var age: int = 0

@onready var raycast: RayCast3D = $RayCast3D

func initialize(_start_pos: Vector3, _start_dir: Vector3, _start_speed: float) -> void:
	global_position = _start_pos
	direction = _start_dir.normalized()
	velocity = direction * _start_speed
	speed = _start_speed
 
func _physics_process(delta: float) -> void:
	age += 1
	if age >= lifetime:
		queue_free()

	# Our current speed, the mag, times the ticklen, this is our distance between now and the end of next tick
	var look_dist = velocity.length() * delta
	
	# Set the direction
	raycast.target_position = velocity.normalized() * look_dist
	raycast.force_raycast_update() # We want to update halfway through the tick

	if raycast.is_colliding():
		# We are hitting a wall, and our target is throuh the wall
		print("ray hit")
		queue_free()
		return

	global_position += velocity * delta

func _on_body_entered(body: Node3D) -> void:
	print("hit suntin")
	queue_free()

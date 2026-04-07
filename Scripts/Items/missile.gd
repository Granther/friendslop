extends Node3D

@export var speed: float = 100
@export var steer_force: float = 1.0
@export var target: Node3D

var velocity = Vector3.ZERO
var accel = Vector3(0, 9.8, 0)
var direction: Vector3
var lock: bool = false

@onready var ray = $RayCast3D
@onready var timer = $GetLockTimer

func _ready():
	timer.start()
	pass

func seek():
	var steer_vec = Vector3.ZERO
	if lock:
		var desired = (target.global_position - global_position).normalized() * speed
		steer_vec = (desired - velocity).normalized() * steer_force
	return steer_vec

func _physics_process(delta: float) -> void:
	accel += seek()
	velocity += accel * delta
	# velocity.clamp(1, speed)
	self.look_at(-velocity)
	#rotation = velocity.angle_to
	# rotation = velocity.normalized()
	position += velocity * delta
	#ray.rotation = direction
	
	

func _on_get_lock_timer_timeout() -> void:
	lock = true

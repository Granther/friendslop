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
	# get_tree().node_added.connect(node_added)
	
	timer.start()

func node_added(node: Node3D):
	if node is CharacterBody3D:
		target = node

func seek():
	var steer_vec = Vector3.ZERO
	if lock:
		# Desired is the direct psitional difference between both, magnified by speed
		var desired = (target.position - position).normalized() * speed
		# Our steer vec is the force to move our current direction to the desired one, this grows with steer_force
		steer_vec = (desired - velocity).normalized() * steer_force
		return steer_vec
	else:
		return Vector3(0,1,0)

func _physics_process(delta: float) -> void:
	# When we += our accel with see(), we gat a wave because as we grow away, since we are adding,we grow further, so seek() keep growing directionally. We pass it and accel starts going in the opposite sign, so we hit a peak, then begin heading down, but since we spend more time going down, the accel grows more
	velocity += seek() * delta
	## velocity.clamp(1, speed)
	##rotation = velocity.angle_to
	## rotation = velocity.normalized()
	position += velocity * delta
	#ray.rotation = direction
	#if target != null:
		#look_at(velocity, Vector3(0,0,1))
	
func _on_get_lock_timer_timeout() -> void:
	lock = true
	#pass

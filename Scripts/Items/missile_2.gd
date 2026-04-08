extends RigidBody3D

@export var speed: float = 3
# Maybe get more accurate as it gets closer??
@export var steer_force: float = 1
@export var target: Node3D = null

var velocity = Vector3.ZERO
var accel = Vector3(0, 9.8*1.2, 0)
var direction
var locked: bool = false
var rot = Vector3()
var distance
var start_dist

@onready var ray = $RayCast3D
@onready var timer = $LockTimer
@onready var anim_player = $AnimatedSprite3D
@onready var coll_shape = $CollisionShape3D
@onready var mesh_inst = $MeshInstance3D

func _ready():
	anim_player.hide()
	get_tree().node_added.connect(node_added)
	timer.start()

func node_added(node: Node3D):
	if node is CharacterBody3D:
		target = node

func seek():
	var steer_vec = Vector3.ZERO
	if locked:
		var desired = (target.position - position).normalized() * speed
		# This is our "Course correction"
		steer_vec = (desired - velocity).normalized() * steer_force
	return steer_vec

# We have a target and are locked, so we get the accel 

func _physics_process(delta: float) -> void:
	if target != null and locked:
		#var dir = target.position - position
		#
		#
		## If zero, we do no course correction
		#accel += seek()
	#velocity += accel * delta
	#position += velocity * delta
		# We want the vector to be in the direction of the target
		# target, but remove the direction of our position
		direction = target.position - position
		direction = direction.normalized()
		var rotAmount = direction.cross(global_transform.basis.z)
		rot.y = rotAmount.y * steer_force * delta
		rot.x = rotAmount.x * steer_force * delta
		rotate(Vector3.UP, rot.y)
		rotate(Vector3.RIGHT, rot.x)
		
	# -global_transform.basis.z is our forward, so we are merely setting vclocity
	global_translate(-global_transform.basis.z * speed * delta)

func _on_lock_timer_timeout() -> void:
	locked = true
	start_dist = (target.position - position).length()

func _on_kill_area_body_entered(body: Node3D) -> void:
	# mesh_inst.hide()
	set_physics_process(false)
	# coll_shape.set_deferred("disabled", true)
	anim_player.show()
	anim_player.play("explosion2")
	await anim_player.animation_finished
	# queue_free()

#extends RigidBody3D
#
#@export var speed: float = 3
## Maybe get more accurate as it gets closer??
#@export var steer_force: float = 1
#@export var target: Node3D = null
#
#var velocity = Vector3.ZERO
#var accel = Vector3(0, 0, 0)
#var direction
#var locked: bool = false
#var rot = Vector3()
#var distance
#var start_dist
#
#@onready var ray = $RayCast3D
#@onready var timer = $LockTimer
#@onready var anim_player = $AnimatedSprite3D
#@onready var coll_shape = $CollisionShape3D
#@onready var mesh_inst = $MeshInstance3D
#
#func _ready():
	#anim_player.hide()
	#get_tree().node_added.connect(node_added)
	#timer.start()
#
#func node_added(node: Node3D):
	#if node is CharacterBody3D:
		#target = node
#
#func _physics_process(delta: float) -> void:
	#if target != null and locked:
		## We want the vector to be in the direction of the target
		## target, but remove the direction of our position
		#direction = target.position - position
		## Then, only preserve the direction
		#distance = direction.length()
		#direction = direction.normalized()
		## print("Basis: ", global_transform.basis, " ", global_transform.basis.z)
		## This returns a vector orthagonal to both vectors
		#var rotAmount = direction.cross(global_transform.basis.z)
		#rot.y = rotAmount.y * steer_force * delta
		#rot.x = rotAmount.x * steer_force * delta
		#rotate(Vector3.UP, rot.y)
		#rotate(Vector3.RIGHT, rot.x)
		#
	## -global_transform.basis.z is our forward, so we are merely setting vclocity
	#global_translate(-global_transform.basis.z * speed * delta)
	#
	##accel += seek()
	##velocity += accel * delta
	#### velocity.clamp(1, speed)
	####rotation = velocity.angle_to
	#### rotation = velocity.normalized()
	##position += velocity * delta
	###ray.rotation = direction
	##if target != null:
		##look_at(velocity, Vector3(0,0,1))
#
#func _on_lock_timer_timeout() -> void:
	#locked = true
	#start_dist = (target.position - position).length()
#
#func _on_kill_area_body_entered(body: Node3D) -> void:
	#mesh_inst.hide()
	#set_physics_process(false)
	#coll_shape.set_deferred("disabled", true)
	#anim_player.show()
	#anim_player.play("explosion2")
	#await anim_player.animation_finished
	#queue_free()

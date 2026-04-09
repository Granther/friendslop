extends RigidBody3D

@export var speed: float = 3
# Maybe get more accurate as it gets closer??
@export var steer_force: float = 1
@export var target: Node3D = null
@export var lock_time: float
@export var launch_time: float 

var velocity = Vector3.ZERO
var accel = Vector3(0, 0, 0)
var direction
var locked: bool = false
var rot = Vector3()
var distance
var start_dist
var in_hand: bool = false
var rot_in_hand: Vector3
var armed: bool = false

@onready var ray = $RayCast3D
@onready var lock_timer = $LockTimer
@onready var launch_timer = $LaunchTimer
@onready var motor_timer = $MotorTimer
@onready var anim_player = $AnimatedSprite3D
@onready var coll_shape = $CollisionShape3D
@onready var mesh_inst = $MeshInstance3D
@onready var rng = RandomNumberGenerator.new()
@onready var kill_area = $KillArea
@onready var item_comp = $ItemComp
@onready var interact_area = $InteractionArea

func _ready():
	launch_timer.wait_time = launch_time
	lock_timer.wait_time = lock_time
	anim_player.hide()
	if target == null:
		get_tree().node_added.connect(node_added)
	# set_physics_process(false)
	# launch_timer.start()
	kill_area.set_deferred("disabled", true)

	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "on_inter")

#func _prep_grab():
	#interact_area.set_collision_layer_value(5, false)
	#interact_area.set_label_visible(false)
	#in_hand = true
	#rot_in_hand = rotation
	##lock_rotation = true
	#pass
	
func _on_interact():
	pass

func _on_drop():
	item_comp.item_manager.drop_item()
	item_comp.phys_func = func(): pass
	interact_area.set_collision_layer_value(5, true)
	interact_area.set_label_visible(true)

func get_motor_accel():
	#var motor_accel = pow(9.8, ((motor_timer.wait_time - motor_timer.time_left)/4))
	#print("Notor accel: ", motor_accel, motor_timer.wait_time - motor_timer.time_left)
	#return Vector3(0, motor_accel, 0)
	# return Vector3(0,9.8*5.5,0)
	return Vector3(0,0,0)

func node_added(node: Node3D):
	if node is CharacterBody3D:
		target = node

func seek():
	# var motor_accel = Vector3(0,9.8*5.5,0)
	var steer_vec = Vector3.ZERO
	if locked:
		var desired = (target.position - position).normalized() * speed
		#if rng.randf_range(0, 100) > 60:
			#var r = 60
			#var rand_vec = Vector3(rng.randf_range(-r, r), rng.randf_range(-r, r), rng.randf_range(-r, r))
			#desired += rand_vec
		# This is our "Course correction"
		# We grow the magnitude based off the steer force
		steer_vec = (desired - velocity).normalized() * steer_force
		return steer_vec + get_motor_accel()
	else:
		return get_motor_accel()

# We have a target and are locked, so we get the accel 

func _physics_process(delta: float) -> void:
	item_comp.phys_func.call()
	#if target != null and locked:
		#var dir = target.position - position
		#
		#
		## If zero, we do no course correction
	velocity += seek() * delta
	# position += velocity * delta
	global_translate(velocity * delta)
		# We want the vector to be in the direction of the target
		# target, but remove the direction of our position
	if locked:
		var desired = (target.position - position).normalized() * speed
		var steer_vec = (desired - velocity).normalized() * steer_force
		var rotAmount = velocity.normalized().cross(global_transform.basis.z)
		rot.y = rotAmount.y
		rot.x = rotAmount.x
		rotate(Vector3.UP, rot.y)
		rotate(Vector3.RIGHT, rot.x)
		#
	## -global_transform.basis.z is our forward, so we are merely setting vclocity
	#global_translate(-global_transform.basis.z * speed * delta)

func _on_launch_timer_timeout() -> void:
	lock_timer.start()
	motor_timer.start()
	set_physics_process(true)

func _on_lock_timer_timeout() -> void:
	kill_area.set_collision_mask_value(1, true)
	locked = true
	start_dist = (target.position - position).length()

func _on_kill_area_body_entered(body: Node3D) -> void:
	item_comp.prep_drop.call()
	mesh_inst.hide()
	set_physics_process(false)
	coll_shape.set_deferred("disabled", true)
	anim_player.show()
	anim_player.play("explosion2")
	await anim_player.animation_finished
	queue_free()

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

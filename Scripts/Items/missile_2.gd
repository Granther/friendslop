extends RigidBody3D

@export var speed: float = 3
@export var steer_force: float = 1
@export var target: Node3D = null
@export var lock_time: float
@export var launch_time: float 
@export var motor_time: float = 2
@export var motor_gs: float = 3

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
var whitelist: Array[Node3D]

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
@onready var interaction_area = $InteractionArea


# Beignin at ready 
# Once launched, starts lock timer, which means i

# Accel ~4, speed 5, steer_force = 50. Accurate at close range but drifts over time with large miss
# Possible over velocity? 

func _ready():
	setup_interact_callables()
	launch_timer.wait_time = launch_time
	lock_timer.wait_time = lock_time
	motor_timer.wait_time = motor_time
	anim_player.hide()
	if target == null:
		get_tree().node_added.connect(node_added)

func get_motor_accel():
	return motor_gs * 9.8

func node_added(node: Node3D):
	if node is CharacterBody3D:
		target = node

func launch():
	armed = true
	lock_timer.start()
	velocity = Vector3.ZERO
	start_motor()

func start_motor():
	motor_timer.start()

func update_motor_const_force():
	# F = ma, end line.
	if not motor_timer.is_stopped(): # Motor is currently firing
		constant_force = -global_transform.basis.z * (mass * get_motor_accel())
	else:
		constant_force = Vector3.ZERO

func _physics_process(delta: float) -> void:
	item_comp.phys_func.call()
	if locked:
		var desired = (target.global_position - global_position).normalized() * speed
		var steer_vec = (desired - velocity).normalized() * steer_force
		var rotAmount = velocity.normalized().cross(global_transform.basis.z)
		rot.y = rotAmount.y
		rot.x = rotAmount.x
		rotate(Vector3.UP, rot.y)
		rotate(Vector3.RIGHT, rot.x)
		velocity += steer_vec * delta
		global_translate(velocity * delta)
	update_motor_const_force()
		
func _on_launch_timer_timeout() -> void:
	lock_timer.start()
	motor_timer.start()
	set_physics_process(true)

func _on_lock_timer_timeout() -> void:
	kill_area.set_collision_mask_value(1, true)
	locked = true

func _on_motor_timer_timeout() -> void:
	# motor_accel = Vector3.ZERO
	pass

func _on_kill_area_body_entered(body: Node3D) -> void:
	if armed and (body not in whitelist):
		set_physics_process(false)
		anim_player.top_level = true
		anim_player.global_position = global_position
		anim_player.show()
		anim_player.play("explosion2")
		mesh_inst.hide()
		coll_shape.set_deferred("disabled", true)
		await anim_player.animation_finished
		queue_free()

func setup_interact_callables():
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

func get_exploded(source: Vector3):
	apply_central_force((global_transform.origin - source).normalized() * 1)

func _on_register():
	rot_in_hand = global_rotation
	item_comp.phys_func = func():
		rotation.z = rot_in_hand.z
		rotation.y = 0;
		item_comp.player_ref.left_arm.global_position = global_position
		item_comp.player_ref.right_arm.global_position = global_position

func _on_deregister():
	item_comp.phys_func = func(): pass

func _on_inter():
	whitelist.append(item_comp.player_ref)
	item_comp.player_ref.item_manager.drop_item()
	interaction_area.set_collision_layer_value(5, true)
	launch()

func _on_drop():
	interaction_area.set_label_visible(true)
	interaction_area.set_collision_layer_value(5, true)
	item_comp.player_ref.item_manager.drop_item()

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

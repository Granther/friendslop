extends CharacterBody3D
signal grabbed(object)

var SPEED = 0
const SPRINT = false
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var BASE_FOV = 120.0
var FOV_CHANGE = 1
var PUSH_FORCE = 4

@onready var head = $Head
# Yeah... These routes look ridiculous, sorry, but, it works. This is so the camera follows the neck of the ragoll basically. I will clean this up later(tm)
@onready var grabbed_anchor = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D/SpringArm3D/GrabbedAnchor"
@onready var object_grabber_shape_cast = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D/ObjectGrabberShapeCast"
@onready var camera = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D"
@onready var animations = $AnimationPlayer
@onready var nametag = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Upper Chest/Nametag"
@export var grabbed_object:RigidBody3D = null
@onready var stoneman = $Head/Stoneman
@onready var ragdoll = $Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var springarm = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D/SpringArm3D"

# Is this ok? With godot I feel like I'm a fricken monkey electrician, just wiring up stuff as I go
# Is there any real best practice here? Is it modular? Does it matter if it isnt?
# @onready var ui = UIHandler.get_ui()
# get_parent().find_child("MainUI")
#  # "$World/MainUI"
@onready var sync = $MultiplayerSynchronizer
var grenade_expl: bool = false
var val: Vector3

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	assert(get_collision_layer_value(4), "must be on 'Expodables' (4) collision layer")

func _ready():
	# Setting nametag of player, be sure to enable billboarding in the flags so it follows the camera
	nametag.text = "Player: " + str(name)
	# Ensures that the spawned characters have default animation blends when spawned in
	stoneman.set_default_anim_blends()
	if not is_multiplayer_authority(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	#if ui.is_menu_open(): return
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("interact"):
			if grabbed_object:
				throw_object()
			elif object_grabber_shape_cast.is_colliding():
				var collided = object_grabber_shape_cast.get_collision_result()[0]["collider"]
				if collided is Ball:
					if !grabbed_object:
						try_grabbing(collided)

func try_grabbing(collided:RigidBody3D):
	grabbed_object = collided
	grabbed_object.set_collision_layer_value(3,0)
	grabbed_object.set_collision_mask_value(2,0)
	emit_signal("grabbed",grabbed_object)
	
func throw_object():
	# Alright, got something working for a sort of lob effect with the ball.
	# Two factors are considered for how far and what angle the item can be thrown: 
	# - Player Velocity
	# - Camera Y Angle
	var throw_angle = clamp(velocity.length() * (camera.rotation.x * 3), -50, 50)
	grabbed_object.apply_impulse((-head.global_basis.z * velocity.length()*2) + Vector3(0,throw_angle,0))
	grabbed_object.set_collision_layer_value(3,1)
	grabbed_object.set_collision_mask_value(2,1)
	grabbed_object = null
	emit_signal("grabbed",grabbed_object)
	pass

# Why does head move on y but camera on x
# Oh! Cause we dont want the whole player to point downward, but we want him to spin
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	#if ui.is_menu_open(): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, 0.2, 1.6)
	


func _physics_process(delta: float) -> void:
	springarm.set("spring_length", clamp(-camera.rotation.x,0.6,0.7))
	
	if not is_multiplayer_authority(): return
	# Bug: Opening menu pauses you in game. Turns off physics lol
	#if ui.is_menu_open(): return
	var velocity_clamp = clamp(velocity.length(), SPEED/4.5, SPEED/4.5)
	var target_fov = BASE_FOV * FOV_CHANGE * velocity_clamp
	camera.fov = lerp(camera.fov, target_fov, delta * 4)
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("ToggleMouseFocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_pressed("sprint"):
		SPEED = 5
		FOV_CHANGE = 0.7
	else:
		SPEED = 3
		FOV_CHANGE = 1
		
	var move_direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !ragdoll.is_simulating_physics():
		if move_direction and is_on_floor():
			velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 6) 
			velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 6) 
		elif is_on_floor():
			velocity.x = velocity.x/1.2
			velocity.z = velocity.z/1.2
		elif not is_on_floor():
			velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 0.5) 
			velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 0.5) 
	else:
		velocity = $"Head/Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Upper Chest".linear_velocity
	
	# Hmmm, so, we essentially have a state machine, but I'm not into that, 
	# So, 
	#if grenade_expl:
		#grenade_expl = false
		#print("Player val: ", velocity, " Val: ", val, " Total: ", (velocity + val))
		#velocity = (velocity + val*5)
		#
	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
			
	if grabbed_object:
		var target_pos:Vector3 = grabbed_anchor.global_position
		
		var current_pos:Vector3 = grabbed_object.global_position
		
		var direction = target_pos - current_pos
		
		var required_velocity = direction / delta
		
		var velocity_correction = required_velocity - grabbed_object.linear_velocity
		grabbed_object.linear_velocity = required_velocity
	proc_anims(velocity)

# This eventually leads to an all-peer rpc call which notifies all peers
func proc_anims(velocity):
	# Interesting, so we get the hypotenuse, want to know how extreme, returns scalar then
	var animationScale = clamp(velocity.length()*2, 0, 15)
	var animationSpeed = clamp(velocity.length()/2, 0, 1)
	stoneman.play_walk_anims(animationScale, animationSpeed)

func get_exploded(source: Vector3):
	# Get difference between player pos and grenade pos (this is our direction relative to grenade)
	var force = (global_transform.origin - source).normalized()*5
	print(force.length())
	velocity = (velocity + force)
	
# So, our force is the [0,1] of the difference 
# If a = [0.5]
# and b = [0.2]. c = [0.3], cn = 0.3/1 = 0.3 

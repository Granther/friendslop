extends CharacterBody3D
signal grabbed(object)

var SPEED = 0
const SPRINT = false
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003
var BASE_FOV = 90
var FOV_CHANGE = 1
var PUSH_FORCE = 4

@export var DEFAULT_SPEED: float = 3

@onready var head = $Head
@onready var grabbed_anchor = $Head/Camera3D/SpringArm3D/GrabbedAnchor
@onready var object_grabber_shape_cast = $Head/Camera3D/ObjectGrabberShapeCast
@onready var camera = $Head/Camera3D
@onready var nametag = $Nametag
@export var grabbed_object:RigidBody3D = null
@onready var stoneman = $Head/Stoneman
@onready var springarm = $Head/Camera3D/SpringArm3D
@onready var ui = UIHandler.get_ui()
@onready var sync = $MultiplayerSynchronizer

@onready var leg_anim_tree = $Head/Stoneman/LegAnimTree
@onready var arm_anim_tree = $Head/Stoneman/ArmAnimTree
@onready var left_arm = $"Head/Stoneman/Left Arm Target"
@onready var right_arm = $"Head/Stoneman/Right Arm Target"

@onready var inter_manager = $PlayerInteractionScanner
@onready var item_manager = $PlayerItemManager
@onready var anim_manager = $PlayerAnimationHandler

@export var interact_dist: float

# Player state machine
var MOVE_STATE: int
const IDLE = 0
const SPRINTING = 1
const WALKING = 2

var STAND_STATE: int
const CROUCHING = 0
const STANDING = 1

func _enter_tree() -> void:
	print("id: ", str(name).to_int())
	set_multiplayer_authority(str(name).to_int())
	#assert(get_collision_layer_value(4), "must be on 'Expodables' (4) collision layer")

func _ready():
	# Setting nametag of player, be sure to enable billboarding in the flags so it follows the camera
	nametag.text = "Player: " + str(name)
	# ItemManager.register_player(self)
	# Ensures that the spawned characters have default animation blends when spawned in
	anim_manager.set_default_anims()
	print(" in ",  str(name).to_int(), " mul: ", get_multiplayer_authority())
	if not is_multiplayer_authority(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.camera.current = true

func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if ui.is_menu_open(): return
	# if event is InputEventMouseButton:
		#if Input.is_action_just_pressed("interact"):

# Why does head move on y but camera on x
# Oh! Cause we dont want the whole player to point downward, but we want him to spin
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if ui.is_menu_open(): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func get_targ_fov(degrees: float) -> float:
	return 0

# We want to set FOV_CHANGE in such a way that it reaches the max fov for the particular state
# ... when we are at the max speed

func _physics_process(delta: float) -> void:
	springarm.set("spring_length", clamp(-camera.rotation.x,0.6,0.7))
		
	if not is_multiplayer_authority():
		#move_and_collide
		#if get_multiplayer_authority() != 1:
			#print(get_slide_collision_count())
		#for i in get_slide_collision_count():
			#var c = get_slide_collision(i)
			#if c.get_collider() is RigidBody3D:
				#c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
		return
	# Bug: Opening menu pauses you in game. Turns off physics lol
	if ui.is_menu_open(): return
	var velocity_clamp = clamp(velocity.length(), SPEED/DEFAULT_SPEED, SPEED/DEFAULT_SPEED)
	var target_fov = BASE_FOV * FOV_CHANGE + velocity_clamp
	camera.fov = lerp(camera.fov, target_fov, delta * 4)
	var input_dir = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("ToggleMouseFocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_pressed("crouch"):
		STAND_STATE = CROUCHING
	else:
		STAND_STATE = STANDING

	if Input.is_action_pressed("sprint"):
		MOVE_STATE = SPRINTING
	elif input_dir != Vector2.ZERO: # sees if we are actually giving input from keyboard
		MOVE_STATE = WALKING
	else:
		MOVE_STATE = IDLE
	
	match(MOVE_STATE):
		SPRINTING:
			if STAND_STATE == CROUCHING:
				SPEED = 2.25
				FOV_CHANGE = 1
			else: # standing
				SPEED = 5
				FOV_CHANGE = 1.1
		WALKING:
			if STAND_STATE == CROUCHING:
				SPEED = DEFAULT_SPEED/2
				FOV_CHANGE = 1
			else: # standing
				SPEED = DEFAULT_SPEED
				FOV_CHANGE = 1
		IDLE:
			SPEED = DEFAULT_SPEED
			FOV_CHANGE = 1

	var move_direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_direction and is_on_floor():
		velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 6) 
		velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 6) 
	elif is_on_floor():
			velocity.x = velocity.x/1.2
			velocity.z = velocity.z/1.2
	elif not is_on_floor():
		velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 0.5) 
		velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 0.5) 
	
	# Hmmm, so, we essentially have a state machine, but I'm not into that, 
	# So, 
	#if grenade_expl:
		#grenade_expl = false
		#print("Player val: ", velocity, " Val: ", val, " Total: ", (velocity + val))
		#velocity = (velocity + val*5)
		#
	move_and_slide()
	
	# returns collisions in the last move_and_slide call
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var body = col.get_collider()
	
		if body is RigidBody3D:
			# a normal is a unit vector point perpendicular the surface of the object in the direction of collision
			var impulse = -col.get_normal() * PUSH_FORCE
			# And, a path is relative to our running scene, this makes sense since we cant serialize with RPC
			server_push_object.rpc_id(1, body.get_path(), impulse)

	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			## c.get_collider().set_multiplayer_authority(get_multiplayer_authority())
			#if multiplayer.is_server(): # ie, player is server
				#c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
			#else:
				## call as if you are the server
				#apply_force_rpc.rpc_id(1, c.get_collider())
	
	if is_on_floor():
		anim_manager.play_walk_anims(velocity.length())
	else:
		anim_manager.play_jump_anims(velocity.length())

# call local, pusher could be server
@rpc("any_peer", "call_local")
func server_push_object(path, impulse):
	if multiplayer.is_server():
		var obj = get_node(path)
		if obj is RigidBody3D:
			print("applied inpusle")
			#obj.apply_central_impulse(impulse)
			obj.apply_central_force(impulse)
			await get_tree().create_timer(0.5).timeout

#@rpc("any_peer", "call_remote", "reliable")
#@rpc
#func apply_force_rpc(r: RigidBody3D):
	#r.apply_central_impulse(-r.get_normal() * PUSH_FORCE)
#
#@rpc("any_peer", "call_local", "reliable")
#func do_hit():
	#for i in get_slide_collision_count():
		#var c = get_slide_collision(i)
		#if c.get_collider() is RigidBody3D:
			#c.get_collider().set_multiplayer_authority(get_multiplayer_authority())
			#c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)

func get_blasted(source: Vector3, force_mag: float):
	# Get difference between player pos and grenade pos (this is our direction relative to grenade)
	print("got blasted")
	var force = (global_transform.origin - source).normalized()*force_mag
	velocity = (velocity + force)

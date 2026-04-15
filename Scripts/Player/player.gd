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
@onready var grabbed_anchor = $Head/Camera3D/SpringArm3D/GrabbedAnchor
@onready var object_grabber_shape_cast = $Head/Camera3D/ObjectGrabberShapeCast
@onready var camera = $Head/Camera3D
@onready var animations = $AnimationPlayer
@onready var nametag = $Nametag
@export var grabbed_object:RigidBody3D = null
@onready var stoneman = $Head/Stoneman
@onready var springarm = $Head/Camera3D/SpringArm3D
@onready var ui = UIHandler.get_ui()
@onready var interaction_area = $InteractionArea
@onready var interaction_collision_shape = $InteractionArea/CollisionShape3D
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
var STATE: int
const SPRINTING = 0
const CROUCHING = 1
const WALKING = 2

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	assert(get_collision_layer_value(4), "must be on 'Expodables' (4) collision layer")

func _ready():
	# Setting nametag of player, be sure to enable billboarding in the flags so it follows the camera
	nametag.text = "Player: " + str(name)
	# ItemManager.register_player(self)
	# Ensures that the spawned characters have default animation blends when spawned in
	anim_manager.set_default_anims()
	if not is_multiplayer_authority(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.current = true

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

func _physics_process(delta: float) -> void:
	springarm.set("spring_length", clamp(-camera.rotation.x,0.6,0.7))
	
	if not is_multiplayer_authority(): return
	# Bug: Opening menu pauses you in game. Turns off physics lol
	if ui.is_menu_open(): return
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
		
	if Input.is_action_pressed("crouch"):
		STATE = CROUCHING
	elif Input.is_action_pressed("sprint"):
		STATE = SPRINTING
	else:
		STATE = WALKING
	
	match(STATE):
		SPRINTING:
			SPEED = 5
#			FOV_CHANGE = 0.7
		WALKING:
			SPEED = 3
#			FOV_CHANGE = 1
		CROUCHING:
			SPEED = 1.5

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
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			c.get_collider().apply_central_impulse(-c.get_normal() * PUSH_FORCE)
	
	if is_on_floor():
		anim_manager.play_walk_anims(velocity.length())
	else:
		anim_manager.play_jump_anims(velocity.length())

func get_exploded(source: Vector3):
	# Get difference between player pos and grenade pos (this is our direction relative to grenade)
	var force = (global_transform.origin - source).normalized()*5
	print(force.length())
	velocity = (velocity + force)

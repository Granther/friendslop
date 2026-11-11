extends BasePlayer

# Controller player, only controlled by the player actually on the computer running program

# Components
@onready var inter_manager = $PlayerInteractionScanner
@onready var item_manager = $PlayerItemManager
@onready var body_manager = $PlayerBodyHandler
@onready var movement_manager = $PlayerMovementHandler
@onready var hud_manager = $PlayerHUDManager

func _ready():
	#print("in ctrl")
	basic_setup() # common to base_player
	_set_visibilities()
	movement_manager.set_player_phys(_movement_phys)
	body_manager.idle() # Set arms to idle pos in case they ain't in the editor
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	object_grab_raycast.target_position = Vector3(0, -GRAB_DIST, 0)
	camera.current = true # we are the local player

func _input(event: InputEvent) -> void:
	if menu.is_menu_open(): return

# Why does head move on y but camera on x
# Oh! Cause we dont want the whole player to point downward, but we want him to spin
func _unhandled_input(event):
	#print(menu.is_menu_open())
	if menu.is_menu_open(): return
	if movement_manager.INPUT_DST == movement_manager.INPUT_OPT.NONE: return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * SENSITIVITY)
		head.rotate_x(event.relative.y * SENSITIVITY)
		## print(rad_to_deg(head.rotation.x))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(0), deg_to_rad(180))

# We want to set FOV_CHANGE in such a way that it reaches the max fov for the particular state
# ... when we are at the max speed

func _physics_process(delta: float) -> void:
	# Process for all our components
	# hollup, dont these all need delta?
	inter_manager.phys_func.call()
	item_manager.phys_func.call()
	anim_manager.phys_func.call()
	body_manager.phys_func.call()
	movement_manager.phys_func.call(delta)

func _process(delta: float) -> void:
	inter_manager.proc_func.call()
	item_manager.proc_func.call()
	anim_manager.proc_func.call()
	body_manager.proc_func.call()
	_movement_proc(delta)

func _movement_phys(delta: float): 
	springarm.set("spring_length", clamp(-camera.rotation.x,0.6,0.7))
	
	var velocity_clamp = clamp(velocity.length(), SPEED/DEFAULT_SPEED, SPEED/DEFAULT_SPEED)
	var target_fov = BASE_FOV * FOV_CHANGE + velocity_clamp
	camera.fov = lerp(camera.fov, target_fov, delta * 4)
	var input_dir = Input.get_vector("right", "left", "down", "up")
	
	if Input.is_action_pressed("ToggleMouseFocus"):
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
	if not is_on_floor():
		velocity += get_gravity() * delta

	if _can_jump and Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y += JUMP_VELOCITY
		
	if Input.is_action_pressed("crouch"):
		STAND_STATE = STAND_STATE_MODE.CROUCHING
		# emission
	else:
		STAND_STATE = STAND_STATE_MODE.STANDING

	if Input.is_action_pressed("ragdoll"):
		stoneman.toggle_ragdoll.rpc()

	if Input.is_action_pressed("sprint"):
		MOVE_STATE = MOVE_STATE_MODE.SPRINTING
	elif input_dir != Vector2.ZERO: # sees if we are actually giving input from keyboard
		MOVE_STATE = MOVE_STATE_MODE.WALKING
	else:
		MOVE_STATE = MOVE_STATE_MODE.IDLE
	
	match(MOVE_STATE):
		MOVE_STATE_MODE.SPRINTING:
			if STAND_STATE == STAND_STATE_MODE.CROUCHING:
				SPEED = 2.25
				FOV_CHANGE = 1
			else: # standing
				SPEED = 5
				FOV_CHANGE = 1.1
		MOVE_STATE_MODE.WALKING:
			if STAND_STATE == STAND_STATE_MODE.CROUCHING:
				SPEED = DEFAULT_SPEED/2
				FOV_CHANGE = 1
			else: # standing
				SPEED = DEFAULT_SPEED
				FOV_CHANGE = 1
		MOVE_STATE_MODE.IDLE:
			SPEED = DEFAULT_SPEED
			FOV_CHANGE = 1

	var move_direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if move_direction and is_on_floor():
		velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 6) 
		velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 6) 
	elif is_on_floor():
			velocity.x = velocity.x/1.2
			velocity.z = velocity.z/1.2
	elif not is_on_floor():
		velocity.x = lerp(velocity.x, move_direction.x * SPEED, delta * 0.5) 
		velocity.z = lerp(velocity.z, move_direction.z * SPEED, delta * 0.5) 

	move_and_slide()
	
	# returns collisions in the last move_and_slide call
	for i in get_slide_collision_count():
		var col = get_slide_collision(i)
		var body = col.get_collider()
		# See if the object is synced
		#if body.has_node("PhysItemMultiComp"):
			## a normal is a unit vector point perpendicular the surface of the object in the direction of collision
			#var impulse = -col.get_normal() * PUSH_FORCE
			#body.get_multi_comp().apply_impulse(impulse)
	
	if is_on_floor():
		anim_manager.play_walk_anims(velocity.length())
	else:
		anim_manager.play_jump_anims(velocity.length())
		
func _movement_proc(delta: float):
	camera.current = true # <- this sucks im ngl, get this figured out grant
	# DebugDraw3D.draw_arrow(Vector3.ZERO, Vector3(velocity.x, 0, 0), Color.RED)

func _set_can_jump(pushing: bool):
	_can_jump = not pushing

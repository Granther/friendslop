class_name BasePlayer extends CharacterBody3D

# def GLOBAL_TO_COMPS
@onready var head = %Stoneman/%Head
@onready var grabbed_anchor = %Stoneman/%Head/Camera3D/SpringArm3D/GrabbedAnchor
@onready var object_grabber_shape_cast = %Stoneman/%Head/ObjectGrabberShapeCast
@onready var object_grab_raycast = %Stoneman/%Head/ObjectGrabRayCast
@onready var ranged_raycast = %Stoneman/%Head/RangedRayCast
@onready var nametag = $"Stoneman/Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Upper Chest/Nametag"
@onready var stoneman = %Stoneman
@onready var stoneman_dead = $StonemanDead
@onready var springarm = %Stoneman/%Head/SpringArm3D

# Arms and Legs
@onready var leg_anim_tree = %Stoneman/LegAnimTree
@onready var arm_anim_tree = %Stoneman/ArmAnimTree
@onready var leg_anim_player = %Stoneman/LegAnimPlayer
@onready var arm_anim_player = %Stoneman/ArmAnimPlayer
@onready var left_arm =  $"%Stoneman/Left Arm Target"
@onready var right_arm = $"%Stoneman/Right Arm Target"
@onready var right_hand_in_view_marker: Marker3D = %Stoneman/%RightHandHoldInViewMarker
@onready var center_hold_marker: Marker3D = %Stoneman/%CenterHoldMarker
@onready var right_hand_idle_marker: Marker3D = %Stoneman/%RightHandIdleMarker
@onready var left_hand_idle_marker: Marker3D = %Stoneman/%LeftHandIdleMarker
@onready var right_hand_obj_marker: Marker3D = %Stoneman/%RightHandObjectMarker
@onready var left_hand_obj_marker: Marker3D = %Stoneman/%LeftHandObjectMarker
# undef GLOBAL_TO_COMPS

# Components
@onready var anim_manager = $PlayerAnimationManager

# Player state machine
var MOVE_STATE: MOVE_STATE_MODE
enum MOVE_STATE_MODE { IDLE, SPRINTING, WALKING }

var STAND_STATE: STAND_STATE_MODE
enum STAND_STATE_MODE { CROUCHING, STANDING }

# Listens
# InteractionScanner:mvmnt_pushing_item -> _set_can_jump

# Set by recieving signals from components
var _can_jump: bool = true
# Just to make it easier to reason through authorities etc, if this is true, the code being run
# is for a full controlled player, else, only peer instance stuff
#var is_ctrl_player: bool = is_multiplayer_authority()

func _enter_tree() -> void:
	set_multiplayer_authority(str(name).to_int())
	#assert(get_collision_layer_value(4), "must be on 'Expodables' (4) collision layer")

func _ready():
	Err.push_err_if(true, "scene inhertiing from BasePlayer must override _ready method")

func _basic_setup():
	# Setting nametag of player, be sure to enable billboarding in the flags so it follows the camera
	# Ensures that the spawned characters have default animation blends when spawned in
	#_setup()
	nametag.text = "Player: " + str(name)
	anim_manager.set_default_anims()
	#if not is_multiplayer_authority(): return
	#_set_visibilities()
	#movement_manager.set_player_phys(_movement_phys)
	#body_manager.idle() # Set arms to idle pos in case they ain't in the editor
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#camera.current = true

func _set_visibilities():
	nametag.set_layer_mask_value(1, false)

# Public helper fn to ensure a function is being run only by the player of this local instance
func ensure_event_local(f, ...args):
	if is_multiplayer_authority():
		return f.callv(args)

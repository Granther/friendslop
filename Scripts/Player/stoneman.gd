extends Node3D

@onready var leg_animations = $"LegAnimTree"
@onready var arm_animations = $"ArmAnimTree"
@onready var animation_player = $LegAnimPlayer
@onready var character = get_parent().get_parent()
@onready var right_arm = $"Right Arm Target"
@onready var left_arm = $"Left Arm Target"
var grabbed_object = null
	
func _ready():
	#leg_animations.set("parameters/JumpBlend/blend_amount", 0.2
	pass

func _physics_process(delta: float) -> void:
	if not is_multiplayer_authority(): return
	if grabbed_object == null:
		set_anim_players.rpc(true)
		#leg_animations.set("parameters/Idle/blend_amount", 0)
		set_anim.rpc("parameters/Idle/blend_amount", 0)
	else:
		left_arm.global_position = grabbed_object.global_position
		right_arm.global_position = grabbed_object.global_position
		set_anim_players.rpc(false)
		#leg_animations.set("parameters/Idle/blend_amount", 1)
		set_anim.rpc("parameters/Idle/blend_amount", 1)
		
	#var input_dir = Input.get_vector("left", "right", "up", "down")
	#var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#var velocity = character.velocity.length()
	#var animationScale = clamp(velocity*2, 0, 15)
	#var animationSpeed = clamp(velocity/2, 0, 1)
	#play_walk_anims.rpc(animationSpeed, animationScale)

# So, when we walk on the client, these are called locally, but this is also called for 

# Calls locally and remotely, this is required since the server is also a player
# Some of these flags are experimental
#@rpc("any_peer", "call_local", "unreliable_ordered")
#func play_walk_anims(animationSpeed: int, animationScale: int):
	#if !character.is_on_floor():
		##if not is_multiplayer_authority(): print("not authority but not on floor")
		#leg_animations.set("parameters/JumpBlend/blend_amount", 0.7)
		##print(animationSpeed, animationScale)
		##animationSpeed = 1
		#if (animationSpeed == 0 or animationScale == 0):
			#leg_animations.active = false
			#animation_player.active = false
	#else:
		#leg_animations.set("parameters/JumpBlend/blend_amount", 0.2)
	#
	#leg_animations.set("parameters/WalkSpeed/scale", animationScale)
	#leg_animations.set("parameters/Blend2/blend_amount", animationSpeed)

# Ok, so when I have the rpc decorator here and not on the individual funcs, it does not work
# I think this is partially because the the character.is_on_floor() method doesn't work
# I think this is cause the required data for that is not synced, and cannot be synced (easily)
# so, having a set_anim method which always considers the player's animation player works well
#@rpc("any_peer", "call_local")

func set_default_anim_blends():
	set_anim.rpc("parameters/WalkSpeed/scale", 0)
	set_anim.rpc("parameters/Blend2/blend_amount", 0)

func play_walk_anims(animationScale: float, animationSpeed: float):
	if !character.is_on_floor():
		set_anim.rpc("parameters/JumpBlend/blend_amount", 0.2)
		animationSpeed = 1
	else:
		set_anim.rpc("parameters/JumpBlend/blend_amount", 0.7)
	set_anim.rpc("parameters/WalkSpeed/scale", animationScale)
	set_anim.rpc("parameters/Blend2/blend_amount", animationSpeed)
	
@rpc("any_peer", "call_local")
func set_anim(path, arg):
	leg_animations.set(path, arg)

@rpc("any_peer", "call_local")
func set_anim_players(setting: bool):
	#animation_player.active = setting
	# arm_animations.active = setting
	pass

# Ok, I see, this is ... not exactly cohesive
func _on_character_body_3d_grabbed(object: Variant) -> void:
	if not is_multiplayer_authority(): return
	grabbed_object = object

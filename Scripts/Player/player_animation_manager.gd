extends Node3D

@onready var leg_anim_tree = $"../Head/Stoneman/LegAnimTree"
@onready var arm_anim_tree= $"../Head/Stoneman/ArmAnimTree"
@onready var leg_anim_player = $"../Head/Stoneman/LegAnimPlayer"

var is_holding: bool = false
var cur_item = null
var anim_func = func(): pass

func set_default_anims():
	set_anim.rpc("parameters/WalkSpeed/scale", 0)
	set_anim.rpc("parameters/Blend2/blend_amount", 0)
	
func set_idle_anims():
	anim_func = func():
		set_anim_players.rpc(true)
		set_anim.rpc("parameters/Idle/blend_amount", 0)

func set_grabbed_item_anims(item: Node3D):
	anim_func = func():
		set_anim_players.rpc(false)
		set_anim.rpc("parameters/Idle/blend_amount", 1)

func _physics_process(delta: float) -> void:
	anim_func.call()

#func play_walk_anims(animationScale: float, animationSpeed: float):
	#if !character.is_on_floor():
		#set_anim.rpc("parameters/JumpBlend/blend_amount", 0.2)
		#animationSpeed = 1
	#else:
		#set_anim.rpc("parameters/JumpBlend/blend_amount", 0.7)

func play_jump_anims(vel_magnitude: float):
	var scale = clamp(vel_magnitude*2, 0, 15)
	set_anim.rpc("parameters/JumpBlend/blend_amount", 0.2)
	set_movement_anims(scale, 1)

func play_walk_anims(vel_magnitude: float):
	var scale = clamp(vel_magnitude*2, 0, 15)
	var speed = clamp(vel_magnitude/2, 0, 1)
	set_anim.rpc("parameters/JumpBlend/blend_amount", 0.7)
	set_movement_anims(scale, speed)

func set_movement_anims(scale: float, speed: float):
	set_anim.rpc("parameters/WalkSpeed/scale", scale)
	set_anim.rpc("parameters/Blend2/blend_amount", speed)

@rpc("any_peer", "call_local")
func set_anim(path, arg):
	leg_anim_tree.set(path, arg)

@rpc("any_peer", "call_local")
func set_anim_players(setting: bool):
	arm_anim_tree.active = setting

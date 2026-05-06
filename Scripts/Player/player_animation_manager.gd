extends PlayerComponent

# Animation Handler component
# We want to be able to set all animations from methods called on this
# but, we want it to internally manage it all
# so, when we have an animation, its either one time, as in, its an emote, which runs to completion, or, its setting a pose, I wnat that to be handled here too
# So, we want to set a jumping pose, so we need a leg state
# We also want to have the ragdoll, which would override all other poses

func set_default_anims():
	set_anim.rpc("parameters/WalkSpeed/scale", 0)
	set_anim.rpc("parameters/Blend2/blend_amount", 0)
	
func set_idle_anims():
	proc_func = func():
		set_anim_players.rpc(true)
		set_anim.rpc("parameters/Idle/blend_amount", 0)

func set_crouch_anims(vel_magnitude: float):
	proc_func = func():
		var scale = clamp(vel_magnitude*2, 0, 15)
		set_anim_players.rpc(true)
		set_anim.rpc("parameters/JumpBlend/blend_amount", 0.2)
		set_movement_anims(scale, 1)

func set_grabbed_item_anims(item: Node3D):
	proc_func = func():
		set_anim_players.rpc(false)
		set_anim.rpc("parameters/Idle/blend_amount", 1)

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

func set_holding_arm_pose():
	#set_anim_players(true)
	player_ref.arm_anim_player.play("Grab")

@rpc("any_peer", "call_local")
func set_anim(path, arg):
	player_ref.leg_anim_tree.set(path, arg)

@rpc("any_peer", "call_local")
func set_anim_players(setting: bool):
	return
	player_ref.arm_anim_tree.active = setting

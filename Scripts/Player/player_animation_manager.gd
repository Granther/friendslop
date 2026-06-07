extends PlayerComponent

# Animation Handler component
# We want to be able to set all animations from methods called on this
# but, we want it to internally manage it all
# so, when we have an animation, its either one time, as in, its an emote, which runs to completion, or, its setting a pose, I wnat that to be handled here too
# So, we want to set a jumping pose, so we need a leg state
# We also want to have the ragdoll, which would override all other poses

func _ready():
	super()
	player_ref.get_node("PlayerItemManager").entered_ride.connect(_on_entered_ride)
	player_ref.get_node("PlayerItemManager").exited_ride.connect(_on_exited_ride)
	player_ref.get_node("PlayerItemManager").grabbed_item.connect(_on_item_grabbed)
	player_ref.get_node("PlayerItemManager").dropped_item.connect(_on_item_dropped)
	player_ref.get_node("%Stoneman/ArmAnimPlayer").play("Idle")

func _on_item_grabbed():
	player_ref.get_node("%Stoneman/ArmAnimPlayer").stop()

func _on_item_dropped():
	player_ref.get_node("%Stoneman/ArmAnimPlayer").play("Idle")

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
	player_ref.get_node("%Stoneman/ArmAnimPlayer").play("Grab")

func _on_exited_ride() -> void:
	player_ref.get_node("%Stoneman/LegAnimPlayer").play("RESET")
	player_ref.get_node("%Stoneman/LegAnimTree").active = true
	player_ref.is_riding = false
	player_ref.head_yaw = 0.0
	player_ref.head_pitch = 0.0
	player_ref.rotate_y(deg_to_rad(-90))
	pass # Replace with function body.

func _on_entered_ride(phys_func: Callable) -> void:
	player_ref.get_node("%Stoneman/LegAnimTree").active = false
	player_ref.get_node("%Stoneman/LegAnimPlayer").play("Sit")
	player_ref.rotate_y(deg_to_rad(90))
	player_ref.is_riding = true
	
	
	pass # Replace with function body.

@rpc("any_peer", "call_local")
func set_anim(path, arg):
	player_ref.get_node("%Stoneman/LegAnimTree").set(path, arg)

@rpc("any_peer", "call_local")
func set_anim_players(setting: bool):
	return
	player_ref.arm_anim_tree.active = setting

extends Node3D

var POLAR = false

@onready var leg_animations = $"LegAnimTree"
@onready var arm_animations = $"ArmAnimTree"
@onready var animation_player = $LegAnimPlayer
@onready var character = get_parent().get_parent()
@onready var right_arm = $"Right Arm Target"
@onready var left_arm = $"Left Arm Target"
@onready var ragdoll = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var box_collision  = $"../../CollisionShape3D"
@onready var head_cam = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D"
@onready var head = $Armature/Skeleton3D/Head
@onready var animated_skel = $Armature/Skeleton3D
@export var angular_spring_stiffness: float = 4000.0
@export var angular_spring_damping: float = 80.0
@export var max_angular_force: float = 9999.0
var grabbed_object = null
var physics_bones = []

func _ready():
	ragdoll.physical_bones_start_simulation()
	ragdoll.influence = 0
	physics_bones = ragdoll.get_children().filter(func(x): return x is PhysicalBone3D) # get all the physical bones

#func _physics_process(delta):
	#
	#for b:PhysicalBone3D in physics_bones:
		#var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		#var current_transform: Transform3D = physical_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())

func _process(delta):
	ragdoll.influence = POLAR
	if ragdoll.influence == 0:
		var upper_leg = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Upper Leg_r"
		var lower_leg = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Lower Leg_r"
		var upper_leg_a = $"Armature/Skeleton3D/Upper Leg_r"
		var lower_leg_a = $"Armature/Skeleton3D/Lower Leg_r"
		upper_leg.transform = upper_leg_a.transform
		lower_leg.transform = lower_leg_a.transform
		ragdoll.physical_bones_stop_simulation()		
	elif POLAR == true:
		ragdoll.influence = 1
		ragdoll.physical_bones_start_simulation()

func toggleRagdoll():
	#head_cam.visible = !head_cam.visible
	#head.visible = !head.visible
	#ragdoll.active = !ragdoll.active
	if Input.is_action_just_pressed("ragdoll"):
		POLAR = !POLAR

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, dampening: float) -> Vector3:
	return (stiffness * displacement) - (dampening * current_velocity)

func _physics_process(delta: float) -> void:
	for b:PhysicalBone3D in physics_bones:
		var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		var current_transform: Transform3D = ragdoll.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		var rotation_difference: Basis = (target_transform.basis * current_transform.basis.inverse())
		
		
	if not is_multiplayer_authority(): return
	if grabbed_object == null:
		set_anim_players.rpc(true)
		set_anim.rpc("parameters/Idle/blend_amount", 0)
	else:
		left_arm.global_position = grabbed_object.global_position
		right_arm.global_position = grabbed_object.global_position
		set_anim_players.rpc(false)
		set_anim.rpc("parameters/Idle/blend_amount", 1)
		
	#if ragdoll.is_simulating_physics():
		#position = ragdoll.global_position
	

# Ok, so when I have the rpc decorator here and not on the individual funcs, it does not work
# I think this is partially because the the character.is_on_floor() method doesn't work
# I think this is cause the required data for that is not synced, and cannot be synced (easily)
# so, having a set_anim method which always considers the player's animation player works well
#@rpc("any_peer", "call_local")
func _input(event: InputEvent) -> void:
	if not is_multiplayer_authority(): return
	if Input.is_action_just_pressed("ragdoll"):
		toggleRagdoll()

func set_default_anim_blends():
	set_anim.rpc("parameters/WalkSpeed/scale", 0)
	set_anim.rpc("parameters/Blend2/blend_amount", 0)

func play_walk_anims(animationScale: float, animationSpeed: float):
	if !character.is_on_floor() or POLAR == true:
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
	arm_animations.active = setting

func _on_character_body_3d_grabbed(object: Variant) -> void:
	if not is_multiplayer_authority(): return
	grabbed_object = object

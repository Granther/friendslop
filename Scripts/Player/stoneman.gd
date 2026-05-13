extends Node3D

@export var angular_spring_stiffness: float = 4000.0
@export var angular_spring_damping: float = 80.0
@export var max_angular_force: float = 9999.0

@onready var character = get_parent().get_parent()
@onready var leg_animations = $"LegAnimTree"
@onready var arm_animations = $"ArmAnimTree"
@onready var animation_player = $LegAnimPlayer
@onready var right_arm = $"Right Arm Target"
@onready var left_arm = $"Left Arm Target"
@onready var ragdoll = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var box_collision  = $"../../CollisionShape3D"
@onready var head_cam = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D"
@onready var head = $Armature/Skeleton3D/Head
@onready var animated_skel = $Armature/Skeleton3D

var physics_bones = []

func _ready():
	ragdoll.physical_bones_start_simulation()
	ragdoll.influence = 0
	physics_bones = ragdoll.get_children().filter(func(x): return x is PhysicalBone3D) # get all the physical bones

func _process(delta):
	if not ragdoll.influence:
		var upper_leg = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Upper Leg_r"
		var lower_leg = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Lower Leg_r"
		var upper_leg_a = $"Armature/Skeleton3D/Upper Leg_r"
		var lower_leg_a = $"Armature/Skeleton3D/Lower Leg_r"
		upper_leg.transform = upper_leg_a.transform
		lower_leg.transform = lower_leg_a.transform
		ragdoll.physical_bones_stop_simulation()
	else:
		ragdoll.physical_bones_start_simulation()

@rpc("any_peer", "call_local")
func toggle_ragdoll():
	ragdoll.influence = not ragdoll.influence

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, dampening: float) -> Vector3:
	return (stiffness * displacement) - (dampening * current_velocity)

func _physics_process(delta: float) -> void:
	for b:PhysicalBone3D in physics_bones:
		var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		var current_transform: Transform3D = ragdoll.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		var rotation_difference: Basis = (target_transform.basis * current_transform.basis.inverse())

# Ok, so when I have the rpc decorator here and not on the individual funcs, it does not work
# I think this is partially because the the character.is_on_floor() method doesn't work
# I think this is cause the required data for that is not synced, and cannot be synced (easily)
# so, having a set_anim method which always considers the player's animation player works well
#@rpc("any_peer", "call_local")
#func _input(event: InputEvent) -> void:
	#if not is_multiplayer_authority(): return
	#if Input.is_action_just_pressed("ragdoll"):
		#toggleRagdoll()

#func _physics_process(delta):
	#
	#for b:PhysicalBone3D in physics_bones:
		#var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		#var current_transform: Transform3D = physical_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())

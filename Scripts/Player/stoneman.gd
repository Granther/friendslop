extends Node3D

@export var angular_spring_stiffness: float = 4000.0
@export var angular_spring_damping: float = 80.0
@export var max_angular_force: float = 9999.0

@onready var character = get_parent().get_parent()
@onready var character_body: CharacterBody3D = get_parent()
@onready var leg_animations = $"LegAnimTree"
@onready var arm_animations = $"ArmAnimTree"
@onready var animation_player = $LegAnimPlayer
@onready var right_arm = $"Right Arm Target"
@onready var left_arm = $"Left Arm Target"
@onready var ragdoll = $Armature/Skeleton3D/PhysicalBoneSimulator3D
@onready var box_collision: CollisionShape3D = $"../CollisionShape3D"
@onready var chest_bone: PhysicalBone3D = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Lower Chest"
@onready var head_cam = $"Armature/Skeleton3D/PhysicalBoneSimulator3D/Physical Bone Neck/Camera3D"
@onready var head = $Armature/Skeleton3D/Head
@onready var animated_skel = $Armature/Skeleton3D
@onready var item_manager = $PlayerItemManager

var physics_bones: Array = []
var is_ragdolling: bool = false

func _ready():
	physics_bones = ragdoll.get_children().filter(func(x): return x is PhysicalBone3D)
	# Default state: skeleton drives physical bones.
	# This means b.global_transform always reflects the current animated pose.
	ragdoll.physical_bones_stop_simulation()
	ragdoll.influence = 0

# Toggle ragdoll on/off. influence is a float (0–1) so we can blend it later if needed.
@rpc("any_peer", "call_local")
func toggle_ragdoll():
	if is_ragdolling:
		_stop_ragdoll()
	else:
		_start_ragdoll()

func _start_ragdoll():
	# Snapshot bone transforms while skeleton is still driving them (correct animated pose).
	var pose_snapshot: Array = []
	for b: PhysicalBone3D in physics_bones:
		pose_snapshot.append(b.global_transform)

	# Disable the capsule so the CharacterBody doesn't interfere with ragdoll collisions.
	# The physical bones' own collision shapes handle all interaction with the world.
	box_collision.disabled = true

	# Enable physics, restore the snapshot pose, and inherit the character's velocity.
	ragdoll.physical_bones_start_simulation()
	for i in physics_bones.size():
		physics_bones[i].global_transform = pose_snapshot[i]
		physics_bones[i].linear_velocity = character_body.velocity
		physics_bones[i].angular_velocity = Vector3.ZERO

	ragdoll.influence = 1
	is_ragdolling = true

func _stop_ragdoll():
	# Before stopping simulation, move the CharacterBody to where the ragdoll ended up.
	# This way the character resumes from the correct position, not where they fell from.
	var target_pos = chest_bone.global_position
	if character_body.item_manager.is_ride():
		character_body.item_manager._deregister_ride()
	character_body.global_position = target_pos
	character_body.velocity = Vector3.ZERO

	ragdoll.influence = 0
	ragdoll.physical_bones_stop_simulation()

	# Re-enable the capsule now that the CharacterBody is back in control.
	box_collision.disabled = false
	is_ragdolling = false

func hookes_law(displacement: Vector3, current_velocity: Vector3, stiffness: float, dampening: float) -> Vector3:
	return (stiffness * displacement) - (dampening * current_velocity)

func _physics_process(delta: float) -> void:
	if not is_ragdolling:
		return

	# Do NOT move character_body here — it's the parent of Stoneman, so moving it
	# every frame drags all the physical bones with it and breaks the simulation.
	# Let physics run freely. Position is only synced when ragdoll stops.

	# Spring-based targeting — computes rotation difference per bone.
	# Apply forces here once the spring system is wired up.
	for b: PhysicalBone3D in physics_bones:
		var target_transform: Transform3D = animated_skel.global_transform * animated_skel.get_bone_global_pose(b.get_bone_id())
		var rotation_difference: Basis = target_transform.basis * b.global_transform.basis.inverse()

# Ok, so when I have the rpc decorator here and not on the individual funcs, it does not work.
# I think this is partially because character.is_on_floor() doesn't work across peers —
# the required data isn't synced. Having set_anim called via RPC on each individual func works better.
#@rpc("any_peer", "call_local")
#func _input(event: InputEvent) -> void:
	#if not is_multiplayer_authority(): return
	#if Input.is_action_just_pressed("ragdoll"):
		#toggle_ragdoll.rpc()

extends Node

const N_FRAMES_PER_UPDATE = 5

var frame_count = 0
var tracked_objects: Array[RigidBody3D]
var phys_f_count: int = 0

# We are going to assume that all nodes that use this will have the get_multi_comp method
func register_object(obj: Node3D): 
	tracked_objects.append(obj)

func deregister_object(obj: Node3D): 
	tracked_objects.erase(obj)

func _physics_process(delta: float) -> void:
	phys_f_count += 1
	if multiplayer.is_server():
		if frame_count == N_FRAMES_PER_UPDATE: # Time to rsync
			for obj in tracked_objects:
				# This may look a little confusing
				# We call an rpc somewhere down the line, so ultimatly this obj exists on all other clients and is being synced using the instance data present on the server peer
				obj.get_multi_comp().resync_to_clients.rpc(
					obj.global_position, obj.global_rotation, obj.linear_velocity
				)
			frame_count = 0
		else: 
			frame_count += 1

func get_phys_frame() -> int:
	return phys_f_count

func set_phys_frame(n: int):
	phys_f_count = n

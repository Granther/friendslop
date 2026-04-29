extends Node

const N_FRAMES_PER_UPDATE = 5

var frame_count = 0
var tracked_objects: Array[RigidBody3D]

func register_object(obj: Node3D): 
	tracked_objects.append(obj)

func deregister_object(obj: Node3D): 
	tracked_objects.erase(obj)

func _physics_process(delta: float) -> void:
	if multiplayer.is_server():
		if frame_count == N_FRAMES_PER_UPDATE: # Time to rsync
			for obj in tracked_objects:
				# This may look a little confusing
				# We call an rpc somewhere down the line, so ultimatly this obj exists on all other clients and is being synced using the instance data present on the server peer
				obj.multiplayer_comp.resync_to_clients.rpc(
					obj.global_position, obj.global_rotation, obj.linear_velocity
				)
			frame_count = 0
		else: 
			frame_count += 1

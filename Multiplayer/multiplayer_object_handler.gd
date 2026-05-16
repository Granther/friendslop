#extends Node
#
#const N_FRAMES_PER_UPDATE = 5
#
#var frame_count = 0
#var tracked_objects: Array[RigidBody3D]
#var phys_f_count: int = 0
#var do_p_cnt: bool = false
#
## We are going to assume that all nodes that use this will have the get_multi_comp method
#func register_object(obj: Node3D): 
	#tracked_objects.append(obj)
#
#func deregister_object(obj: Node3D): 
	#tracked_objects.erase(obj)
#
#func _physics_process(delta: float) -> void:
	#if do_p_cnt:
		#phys_f_count += 1
	## if multiplayer.is_server():
	#if true:
		#if frame_count == N_FRAMES_PER_UPDATE: # Time to rsync
			#for obj in tracked_objects:
				## This may look a little confusing
				## We call an rpc somewhere down the line, so ultimatly this obj exists on all other clients and is being synced using the instance data present on the server peer
				#obj.get_multi_comp().resync_to_clients.rpc(
					#obj.global_position, obj.global_rotation, obj.linear_velocity
				#)
			#frame_count = 0
		#else: 
			#frame_count += 1
#
#func get_phys_count() -> int:
	#return phys_f_count
#
#func set_phys_count(n: int):
	#phys_f_count = n
#
#func start_phys_count():
	#do_p_cnt = true

extends Node

const N_FRAMES_PER_UPDATE = 5

var frame_count = 0
var tracked_objects: Array[RigidBody3D]

# We are going to assume that all nodes that use this will have the get_multi_comp method
func register_object(obj: Node3D): 
	tracked_objects.append(obj)

func deregister_object(obj: Node3D): 
	tracked_objects.erase(obj)
#
#func remotify_objs() -> Array[NodePath]:
	#var a: Array[NodePath]
	#for obj in tracked_objects:
		#a.append(obj.get_path())
	#return a
#
#func sync_tracked_objs(a: Array[NodePath]):
	#for p in a:
		#tracked_objects.append(a)

func _physics_process(delta: float) -> void:
	pass

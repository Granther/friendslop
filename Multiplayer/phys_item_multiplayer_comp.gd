class_name PhysItemMultiComp extends Node

# The idea is that this component can be added to any rigid body to allow for multiplayer integration

# percent that position can differ for update not to occur (less jitter)
const MIN_PERC_UPDATE = 15
const NO_OWNER = -1
const HOST = 0

@export var root_obj: Node3D

var state: STATE_MODE = STATE_MODE.FREE
enum STATE_MODE { CARRY, FREE }

var _owner_id: int = HOST

func _ready() -> void:
	Err.push_err_if(not root_obj.has_method("get_multi_comp"), "parent of PhysItemMultiComp MUST have method get_multi_comp() -> PhysItemMultiComp")
	register_to_player()

func register_to_player():
	MultiplayerObjectHandler.register_object(root_obj)

func apply_impulse(impulse: Vector3):
	inform_server.rpc(impulse)

@rpc("any_peer", "call_local")
func inform_server(impulse):
	# Begin counting locally
	# MultiplayerObjectHandler.start_phys_count()
	root_obj.apply_central_impulse(impulse)

@rpc("any_peer", "call_remote")
func resync_to_clients(pos, rot, vel):
	var perc_dif_rot =  (root_obj.global_rotation - rot).length() * 100
	var perc_dif_pos =  (root_obj.global_position - pos).length() * 100
	
	if perc_dif_pos > MIN_PERC_UPDATE:
		root_obj.global_position = pos
		print(pos)
		
	if perc_dif_rot > MIN_PERC_UPDATE:
		root_obj.global_rotation = rot
	
	root_obj.linear_velocity = vel
#
#@rpc("call_local", "any_peer")
#func change_owner(new: int):
	#_owner_id = new
#
#func _physics_process(delta: float) -> void:
	#if multiplayer.get_unique_id() != 0:
		#change_owner(multiplayer.get_unique_id())
#
	## The person who owns this thing is calling phys on it
	#if (multiplayer.get_unique_id() == _owner_id) and MultiplayerObjectHandler.is_update_tick(): 
		#resync_to_clients.rpc(root_obj.global_position, root_obj.global_rotation, #root_obj.linear_velocity)
		#Vector3.ZERO)

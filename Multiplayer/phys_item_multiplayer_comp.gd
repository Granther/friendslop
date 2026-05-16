class_name PhysItemMultiComp extends Node

# The idea is that this component can be added to any rigid body to allow for multiplayer integration

# percent that position can differ for update not to occur (less jitter)
const MIN_PERC_UPDATE = 15
const NO_OWNER = -1

@export var root_obj: Node3D

var _owner_id: int = NO_OWNER

func _ready() -> void:
	Err.push_err_if(not root_obj.has_method("get_multi_comp"), "parent of PhysItemMultiComp MUST have method get_multi_comp() -> PhysItemMultiComp")
	MultiplayerObjectHandler.register_object(root_obj)

func apply_impulse(impulse: Vector3):
	inform_server.rpc(impulse)

func update():
	pass
	
@rpc("any_peer", "call_local")
func inform_server(impulse):
	# Begin counting locally
	MultiplayerObjectHandler.start_phys_count()
	root_obj.apply_central_impulse(impulse)

@rpc("any_peer", "call_remote")
func resync_to_clients(pos, rot, vel):
	var perc_dif_rot =  (root_obj.global_rotation - rot).length() * 100
	var perc_dif_pos =  (root_obj.global_position - pos).length() * 100
	
	if perc_dif_pos > MIN_PERC_UPDATE:
		root_obj.global_position = pos
		
	if perc_dif_rot > MIN_PERC_UPDATE:
		root_obj.global_rotation = rot
	
	root_obj.linear_velocity = vel

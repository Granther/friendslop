extends Node3D

# The idea is that this component can be added to any rigid body to allow for multiplayer integration

# percent that position can differ for update not to occur (less jitter)
const MIN_PERC_UPDATE = 15

@export var root_object: Node3D

func _ready() -> void:
	MultiplayerObjectHandler.register_object(root_object)
	
func apply_impulse(impulse: Vector3):
	inform_server.rpc(impulse)
	
@rpc("any_peer", "call_local")
func inform_server(impulse):
	root_object.apply_central_impulse(impulse)

@rpc("any_peer", "call_remote")
func resync_to_clients(pos, rot, vel):
	var perc_dif_rot =  (root_object.global_rotation - rot).length() * 100
	var perc_dif_pos =  (root_object.global_position - pos).length() * 100
	
	if perc_dif_pos > MIN_PERC_UPDATE:
		root_object.global_position = pos
		
	if perc_dif_rot > MIN_PERC_UPDATE:
		root_object.global_rotation = rot
	
	root_object.linear_velocity = vel

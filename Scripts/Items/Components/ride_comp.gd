class_name RideComponent extends InteractComponent

var phys_movement_func: Callable = func(delta: float): pass
var _on_veh: bool = false

# disables gravity and forces, when its in hands it accumulates a ton of velocity
func _set_freeze(setting: bool):
	if setting:
		root_obj.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
		root_obj.freeze = true
	else:
		root_obj.freeze = false

func _set_col_layers(setting: bool):
	# So the player doesn't collide with the vehicle while in it
	root_obj.set_collision_layer_value(3, setting)
	interaction_area.set_collision_layer_value(5, setting)

func player_on_vehicle() -> bool:
	return _on_veh

func register(player_ref: CharacterBody3D):
	player_ref.reparent(root_obj)
	player_ref.global_position = root_obj.global_position
	player_ref.global_rotation = Vector3.ZERO
	_on_veh = true
	_set_col_layers(false)

func deregister(player_ref: CharacterBody3D):
	player_ref.reparent(WorldAPI.get_world())
	player_ref.global_rotation = Vector3.ZERO
	_on_veh = false
	_set_col_layers(true)

func _on_inter():
	pass

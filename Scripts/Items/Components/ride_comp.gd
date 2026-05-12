class_name RideComponent extends InteractComponent

# disables gravity and forces, when its in hands it accumulates a ton of velocity
func _set_freeze(setting: bool):
	if setting:
		root_obj.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
		root_obj.freeze = true
	else:
		root_obj.freeze = false

func _set_col_layers(setting: bool):
	# So the player doesn't collide with the vehicle while in it
	root_obj.set_collision_layer_value(8, setting)
	interaction_area.set_collision_layer_value(5, setting)

func register():
	_set_col_layers(false)

func deregister():
	_set_col_layers(true)

func _on_inter():
	pass

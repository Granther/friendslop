class_name GrabComponent extends InteractComponent

# disables gravity and forces, when its in hands it accumulates a ton of velocity
func _set_freeze(setting: bool):
	if setting:
		root_obj.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
		root_obj.freeze = true
	else:
		root_obj.freeze = false

func _set_col_layers(setting: bool):
	# Remove from Items and Interactibles. So it wont collide with player and be picked up as item from scanner
	root_obj.set_collision_mask_value(2, setting)
	# root_obj.set_collision_layer_value(3, setting)
	interaction_area.set_collision_layer_value(5, setting)

func register(camera: Camera3D, anchor: Marker3D):
	_multiplayer_register.rpc(camera.get_path(), anchor.get_path())

func deregister():
	_multiplayer_deregister.rpc()

@rpc("call_local", "any_peer")
func _multiplayer_register(cam_path: NodePath, anchor_path: NodePath):
	_set_freeze(true)
	_set_col_layers(false)
	var anchor: Marker3D = get_node(anchor_path)
	var camera: Camera3D = get_node(cam_path)
	root_obj.reparent(anchor)
	root_obj.global_rotation = Vector3.ZERO
	# root_obj.position = Vector3.ZERO
	proc_func = func():
		root_obj.global_rotation = camera.global_rotation
		root_obj.global_position = anchor.global_position

@rpc("call_local", "any_peer")
func _multiplayer_deregister():
	_set_freeze(false)
	_set_col_layers(true)
	root_obj.reparent(WorldAPI.get_world())
	proc_func = NULL_FUNC

func _on_inter():
	print("unimplemented")

func _on_drop():
	interaction_area.set_label_visible(true)

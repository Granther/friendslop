class_name GrabComponent
extends Node

@export var root_obj: RigidBody3D
@export var icomp: InteractComponent

# disables gravity and forces, when its in hands it accumulates a ton of velocity
func _set_freeze(setting: bool):
	if setting:
		root_obj.set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
		root_obj.freeze = true
	else:
		root_obj.freeze = false

func _set_col_layers(setting: bool):
	# Remove from Items and Interactibles. So it wont collide with player and be picked up as item from scanner
	root_obj.set_collision_layer_value(3, not setting)
	icomp.interaction_area.set_collision_layer_value(5, not setting)

func register(camera: Camera3D, anchor: Marker3D):
	_set_col_layers(true)
# 	icomp.interaction_area.set_label_visible(false)
	_set_freeze(true)
	root_obj.global_rotation = Vector3.ZERO
	icomp.proc_func = func():
		root_obj.global_rotation = camera.global_rotation
		root_obj.global_position = anchor.global_position

func deregister():
	_set_freeze(false)
	_set_col_layers(false)
	icomp.proc_func = icomp.NULL_FUNC

func _on_inter():
	print("unimplemented")

func _on_drop():
	icomp.interaction_area.set_label_visible(true)

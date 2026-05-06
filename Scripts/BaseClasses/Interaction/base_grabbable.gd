extends Interactable
class_name Grabbable

# Grabbable
# Used to be extended by grabbable items

# disables gravity and forces, when its in hands it accumulates a ton of velocity
func _set_freeze(setting: bool):
	if setting:
		set_freeze_mode(RigidBody3D.FREEZE_MODE_KINEMATIC)
		freeze = true
	else:
		freeze = false

func _set_col_layers(setting: bool):
	# Remove from Items and Interactibles. So it wont collide with player and be picked up as item from scanner
	set_collision_layer_value(3, not setting)
	interaction_area.set_collision_layer_value(5, not setting)

func register(camera: Camera3D, anchor: Marker3D):
	_set_col_layers(true)
	interaction_area.set_label_visible(false)
	_set_freeze(true)
	global_rotation = Vector3.ZERO
	item_comp.phys_func = func():
		global_rotation = camera.global_rotation
		global_position = anchor.global_position

func deregister():
	_set_freeze(false)
	_set_col_layers(false)
	item_comp.phys_func = item_comp.NULL_FUNC

func _on_inter():
	print("unimplemented")

func _on_drop():
	interaction_area.set_label_visible(true)

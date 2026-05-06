extends Interactable
class_name Grabbable

# Grabbable
# Used to be extended by grabbable items

@export var interaction_area: Area3D
@export var item_comp: Node3D

var in_hand_rot = null

func _runtime_checks():
	# For picking up
	Err.push_err_if(not interaction_area.get_collision_layer_value(5), "grabbable object's InteractionArea must be on the Interactables layer")
	# For colliding with player and world
	Err.push_err_if(not get_collision_layer_value(5), "grabbable object must be on the Interactables layer")

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

func _on_register():
	item_comp.player_ref.anim_manager.set_holding_arm_pose()
	_set_col_layers(true)
	interaction_area.set_label_visible(false)
	_set_freeze(true)
	# rotation = Vector3.ZERO
	global_rotation = Vector3.ZERO
	# rotation.y = global_rotation.y
	item_comp.phys_func = func():
		#global_rotation.y = item_comp.player_ref.global_rotation.y
		#global_rotation.z = in_hand_rot.z
		#global_rotation.x = in_hand_rot.x
		#look_at(item_comp.player_ref.global_position, Vector3.RIGHT)
		#item_comp.player_ref.left_arm.global_position = item_comp.left_hand_anchor.global_position
		#item_comp.player_ref.right_arm.global_position = item_comp.right_hand_anchor.global_position
		
		# Does the player have a front?
		# Using camera, that makes sense
		global_rotation = item_comp.player_ref.camera.global_rotation
		global_position = item_comp.player_ref.body_manager.item_anchor.global_position

func _on_deregister():
	_set_freeze(false)
	_set_col_layers(false)
	item_comp.phys_func = func(): pass

func _on_inter():
	print("unimplemented")

func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.player_ref.item_manager.drop_item()

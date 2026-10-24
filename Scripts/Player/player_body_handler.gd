extends PlayerComponent

# Handles the physical system that is the player. Moving hand to marker 3d
# Managing animations

# Listens
# ItemManager:signal grabbed_item -> set_hands(a, b)
# ItemManager:signal dropped_item -> idle

func set_hands(left_anchor: Marker3D, right_anchor: Marker3D):
	proc_func = func():
		player_ref.right_arm.global_position = right_anchor.global_position
		player_ref.left_arm.global_position = left_anchor.global_position

func idle():
	player_ref.right_arm.global_position = player_ref.right_hand_idle_marker.global_position
	player_ref.left_arm.global_position = player_ref.left_hand_idle_marker.global_position
	proc_func = NULL_FUNC

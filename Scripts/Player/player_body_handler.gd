extends PlayerComponent

# Handles the physical system that is the player. Moving hand to marker 3d
# Managing animations

# Listens
# ItemManager:signal grabbed_item -> right_hand_holding
# ItemManager:signal dropped_item -> right_hand_idle

func right_hand_holding():
	proc_func = func():
		player_ref.right_arm.global_position = player_ref.hip_hold_marker.global_position
	
func right_hand_idle():
	player_ref.right_arm.position = player_ref.idle_hand_marker.global_position
	proc_func = NULL_FUNC

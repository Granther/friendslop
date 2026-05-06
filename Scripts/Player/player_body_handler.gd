extends Component

# Handles the physical system that is the player. Moving hand to marker 3d
# Managing animations

# Listens
# ItemManager:signal grabbed_item -> right_hand_holding
# ItemManager:signal dropped_item -> right_hand_idle

@onready var holding_marker = %HoldingMarker
@onready var hip_hold_marker: Marker3D = %HipHoldMarker
@onready var center_hold_marker: Marker3D = %CenterHoldMarker
@onready var item_anchor: Marker3D = %ItemGrabAnchor

func right_hand_holding():
	proc_func = func():
		player_ref.right_arm.global_position = hip_hold_marker.global_position
	
func right_hand_idle():
	player_ref.right_arm.position = Vector3.ZERO
	proc_func = NULL_FUNC

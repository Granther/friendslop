extends BasePlayer

# this is the id of the ctrl_player that this peer_player inherits the pos from
var ctrl_id: int = -1

func _ready() -> void:
	_basic_setup()
	MultiplayerApi.reposition_shell_peer.connect(_reposition_peer)
	MultiplayerApi.reposition_head_shell_peer.connect(_reposition_peer_head)
	MultiplayerApi.remove_shell_peer.connect(_remove_self)
	MultiplayerApi.inv_pickup_shell_peer.connect(_inv_pickup)

func _peer_is_shell_parent(peer_id: int) -> bool: 
	return (peer_id == ctrl_id)

func _reposition_peer(peer_id: int, pos: Vector3, rot: Vector3) -> void:
	if not _peer_is_shell_parent(peer_id): return
	global_position = pos
	global_rotation = rot

func _reposition_peer_head(peer_id: int, x_rot: float) -> void:
	if not _peer_is_shell_parent(peer_id): return
	head.global_rotation.x = x_rot

func _remove_self(peer_id: int):
	if not _peer_is_shell_parent(peer_id): return
	queue_free()

func _inv_pickup(peer_id: int, item: ResPreloader.ITEM):
	if not _peer_is_shell_parent(peer_id): return
	var item_res: PackedScene = ResPreloader.visuals_dict[item]
	var inv_item: MeshInstance3D = item_res.instantiate()
	add_child(inv_item)
	inv_item.global_position = right_hand_obj_marker.global_position

#func _inv_drop(peer_id: int, item: ResPreloader.ITEM):
	#if not _peer_is_shell_parent(peer_id): return
	#var item_res: PackedScene = ResPreloader.items_dict[item]
	#var inv_item: InvEquip = item_res.instantiate()
	#add_child(inv_item)
	#inv_item.picked_up()
	#inv_item.global_position = right_hand_obj_marker.global_position


# so, every peer_player has a cooresponding ctrl_player
# so we need to have peer_player be linked to the properties of its corresponding ctrler
# but, how do we link if the node isnt local? 
# well, we could add a sync to both the ctrl and peer and cross link them 
# I dont think we can

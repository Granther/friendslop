extends BasePlayer

# this is the id of the ctrl_player that this peer_player inherits the pos from
var ctrl_id: int = -1

func _ready() -> void:
	basic_setup()
	MultiplayerApi.reposition_shell_peer.connect(_reposition_peer)

func _reposition_peer(peer_id: int, pos: Vector3, rot: Vector3) -> void:
	if peer_id != ctrl_id: return # not the right peer
	global_position = pos
	global_rotation = rot

# so, every peer_player has a cooresponding ctrl_player
# so we need to have peer_player be linked to the properties of its corresponding ctrler
# but, how do we link if the node isnt local? 
# well, we could add a sync to both the ctrl and peer and cross link them 
# I dont think we can

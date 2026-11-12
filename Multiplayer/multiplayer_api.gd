extends Node

# This is just an intermediate API between the caller (the player ususally) and the network, worldapi etc

var peer_dict: Dictionary = {}
var peer_id: int = -1 # -1 means we dont have an id yet, so if we get a broadcast, it is for us
# peer_id of the local player on this mchine
# var my_player: Node3D
var peer_ids: Array[int]

# emitted when the peer_id has been set for the client
#signal handle_remote_peer_assign(peer_id: int)
signal handle_local_peer_assign(peer_id: int)

func _ready() -> void:
	pass

func connect_new_player(peer_id: int) -> void:
	if is_multiplayer_authority():
		# we add mindless body
		WorldAPI.current_world.spawn_ctrl_player(peer_id)
	else: # is peer
		WorldAPI.current_world.spawn_peer_player(peer_id)

func handle_remote_peer_assign(peer_id: int) -> void:
	WorldAPI.current_world.spawn_peer_player(peer_id)

func remove_player(peer_id: int) -> void:
	pass

func setup_ctrl_player(peer_id: int) -> void:
	WorldAPI.current_world.spawn_ctrl_player(peer_id)

func post_multiplayer_pos(pos: Vector3, rot: Vector3):
	GrelpMultiplayer.post_pos_rot(peer_id, pos, rot)

#@rpc("call_local", "any_peer")
#func sync_add(p_path: NodePath, peer_id: int):
	#players[peer_id] = get_node(p_path)
#
#func get_player_by_peer_id(peer_id: int) -> Node3D:
	#if players.has(peer_id):
		#return players[peer_id]
	#else: return null
#
#func get_players() -> Dictionary:
	#return players

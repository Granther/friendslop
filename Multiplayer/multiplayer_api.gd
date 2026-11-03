extends Node

var players: Dictionary = {}
var my_peer_id: int
var my_player: Node3D

func _ready() -> void:
	pass

func add_player(player: Node3D, peer_id: int) -> void:
	sync_add.rpc(player.get_path(), peer_id)

func remove_player(peer_id: int) -> void:
	pass

@rpc("call_local", "any_peer")
func sync_add(p_path: NodePath, peer_id: int):
	players[peer_id] = get_node(p_path)

func get_player_by_peer_id(peer_id: int) -> Node3D:
	if players.has(peer_id):
		return players[peer_id]
	else: return null

func get_players() -> Dictionary:
	return players

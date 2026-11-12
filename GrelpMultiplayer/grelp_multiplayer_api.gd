extends Node

func post_pos_rot(peer_id: int, pos: Vector3, rot: Vector3):
	PlayerTransPacket.create(
		peer_id, pos, rot
	).send(GrelpNetHandler.server_peer)

func _ready() -> void:
	GrelpNetHandler.on_peer_connected.connect(on_peer_connected)
	#GrelpNetHandler.on_client_packet.connect(on_client_packet)

# player connected to server, all players should run this
func on_peer_connected(peer_id: int) -> void:
	print("new peer connected")

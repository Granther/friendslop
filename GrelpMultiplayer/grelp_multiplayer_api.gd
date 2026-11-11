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

func on_server_packet(data: PackedByteArray) -> void:
	#match data[0]:
		#BasePacket.PACKET_TYPE.ID_ASSIGNMENT:
			#var peer_id: int = IDPacket.create_from_data(data).id 
			#MultiplayerApi.peer_id = peer_id
			#MultiplayerApi.set_peer_id.emit(peer_id)
	pass
			

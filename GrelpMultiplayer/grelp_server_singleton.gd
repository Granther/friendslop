extends Node

func _ready() -> void:
	#GrelpNetHandler.on_peer_connected.connect(on_peer_connected)
	GrelpNetHandler.on_server_packet.connect(on_server_packet)

# there is no client to client comm, so this all always comes from the server
func on_server_packet(peer_id:int, data: PackedByteArray) -> void:
	match data[0]:
		# player telling us where their pos is
		BasePacket.PACKET_TYPE.PLAYER_TRANSFORM: 
			_handle_player_trans(data)

func _handle_player_trans(data: PackedByteArray) -> void:
	var info: PlayerTransPacket = PlayerTransPacket.create_from_data(data)
	info.broadcast(GrelpNetHandler.connection)

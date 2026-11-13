extends Node

func _ready() -> void:
	GrelpNetHandler.on_server_packet.connect(on_server_packet)
	GrelpNetHandler.on_peer_connected.connect(on_peer_connected)

func on_peer_connected(peer_id: int) -> void:
	MultiplayerApi.peer_ids.append(peer_id)

	# tell all peers that a new player was added
	IDPacket.create(
		peer_id,
		MultiplayerApi.peer_ids
	).broadcast(GrelpNetHandler.connection)

# there is no client to client comm, so this all always comes from the server
func on_server_packet(peer_id:int, data: PackedByteArray) -> void:
	match data[0]:
		# player telling us where their pos is
		BasePacket.PACKET_TYPE.PLAYER_TRANSFORM: 
			_handle_player_trans(data)

func _handle_player_trans(data: PackedByteArray) -> void:
	var info: PlayerTransPacket = PlayerTransPacket.create_from_data(data)
	info.broadcast(GrelpNetHandler.connection)

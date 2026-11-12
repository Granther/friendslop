extends Node

#signal handle_player_position(peer_id: int, player_position: PlayerPosition)

func _ready() -> void:
	GrelpNetHandler.on_peer_connected.connect(on_peer_connected)
	GrelpNetHandler.on_client_packet.connect(on_client_packet)

func on_peer_connected(peer_id: int) -> void:
	MultiplayerApi.peer_ids.append(peer_id)

	# tell all peers that a new player was added
	IDPacket.create(
		peer_id,
		MultiplayerApi.peer_ids
	).broadcast(GrelpNetHandler.connection)

# there is no client to client comm, so this all always comes from the server
func on_client_packet(data: PackedByteArray) -> void:
	match data[0]:
		# all clients recv this
		BasePacket.PACKET_TYPE.ID_ASSIGNMENT:
			_handle_id_assign(data)
		BasePacket.PACKET_TYPE.PLAYER_TRANSFORM: # we always get this from the server
			_handle_player_trans(data)

func _handle_player_trans(data: PackedByteArray) -> void:
	var info: PlayerTransPacket = PlayerTransPacket.create_from_data(data)
	if info.id == MultiplayerApi.peer_id: return # return if its outselves
	var pos: Vector3 = Vector3(info.pos.x, info.pos.y, info.pos.z)
	var rot: Vector3 = Vector3(info.rot.x, info.rot.y, info.rot.z)
	MultiplayerApi.reposition_shell_peer.emit(info.id, pos, rot)
	# print(pos, rot, info.id)
	#var player: Node3D = get_node(MultiplayerApi.peer_dict[info.id])
	#get_tree().root.find_child(str(info.id))
	#print(player)
	# we get pos packet from server, if its for us, drop
	# if its not, set that for the appropiete peer on the game

func _handle_id_assign(data: PackedByteArray):
	var info: IDPacket = IDPacket.create_from_data(data)
	#print(info.peer_ids)
	if MultiplayerApi.peer_id == -1:
		MultiplayerApi.peer_id = info.id
		MultiplayerApi.peer_ids = info.peer_ids
		MultiplayerApi.handle_local_peer_assign.emit(info.id)
		info.peer_ids.erase(info.id)
		print(info.peer_ids, " for peer_id: ", info.id)
		for peer_id in info.peer_ids:
			#if peer_id == info.id: continue
			# the new player gets all of the already present players handled
			#MultiplayerApi.handle_remote_peer_assign.emit(info.id)
			MultiplayerApi.handle_remote_peer_assign(info.id)
			print("handle for: ", info.id)
	else: # already have peer_id, but now we know new player has spawned, setup..
		# now we, the people already w/ ids handle the new player
		MultiplayerApi.peer_ids.append(info.id)
		#MultiplayerApi.handle_remote_peer_assign.emit(info.id)
		MultiplayerApi.handle_remote_peer_assign(info.id)
		
	print("new peer_id: ", MultiplayerApi.peer_id)

#func on_peer_disconnected(peer_id: int) -> void:
	#peer_ids.erase(peer_id)
#
	## Create IDUnassignment to broadcast to all still connected peers
#
#
#func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	#match data[0]:
		#PacketInfo.PACKET_TYPE.PLAYER_POSITION:
			#handle_player_position.emit(peer_id, PlayerPosition.create_from_data(data))
		#_:
			#push_error("Packet type with index ", data[0], " unhandled!")

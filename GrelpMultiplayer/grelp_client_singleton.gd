extends Node

func _ready() -> void:
	GrelpNetHandler.on_client_packet.connect(_on_client_packet)
	# GrelpNetHandler.on_peer_disconnected.connect(_peer_disconnected)

# there is no client to client comm, so this all always comes from the server
func _on_client_packet(data: PackedByteArray) -> void:
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
	# we get pos packet from server, if its for us, drop
	# if its not, set that for the appropiete peer on the game

func _handle_id_assign(data: PackedByteArray):
	var info: IDPacket = IDPacket.create_from_data(data)
	if MultiplayerApi.peer_id == -1:
		MultiplayerApi.peer_id = info.id
		MultiplayerApi.peer_ids = info.peer_ids
		MultiplayerApi.handle_local_peer_assign.emit(info.id)
		for peer_id in info.peer_ids:
			if peer_id == info.id: continue
			# the new player gets all of the already present players handled
			MultiplayerApi.setup_new_peer_shell(peer_id)
	else: # already have peer_id, but now we know new player has spawned, setup..
		# now we, the people already w/ ids handle the new player
		MultiplayerApi.peer_ids.append(info.id)
		MultiplayerApi.setup_new_peer_shell(info.id)

# this needs to be worked on etc
func _peer_disconnected(peer_id: int) -> void:
	MultiplayerApi.peer_ids.erase(peer_id)
	MultiplayerApi.remove_shell_peer.emit(peer_id)

extends Node

# Gamestate
# each player has health, inv, and pos/rot
var players: Dictionary
var items: Dictionary

func _ready() -> void:
	GrelpNetHandler.on_server_packet.connect(on_server_packet)
	GrelpNetHandler.on_peer_connected.connect(on_peer_connected)

func on_peer_connected(peer_id: int) -> void:
	MultiplayerApi.peer_ids.append(peer_id)
	_create_gs_player(peer_id, 100, 3, Vector3.ZERO, Vector3.ZERO)
	# tell all peers that a new player was added
	IDPacket.create(
		peer_id,
		peer_id,
		MultiplayerApi.peer_ids
	).broadcast(GrelpNetHandler.connection)

func on_server_packet(peer_id: int, data: PackedByteArray) -> void:
	match data[0]:
		# player telling us where their pos is
		BasePacket.PACKET_TYPE.PLAYER_TRANSFORM: 
			_handle_gs_player_trans(data)
		BasePacket.PACKET_TYPE.PLAYER_HEAD_TRANSFORM: 
			_handle_gs_player_head_trans(data)
		BasePacket.PACKET_TYPE.INVENTORY:
			_handle_gs_player_inv(data)
		BasePacket.PACKET_TYPE.ITEM_UPDATE:
			_handle_gs_item_up(data)

func _handle_player_trans(data: PackedByteArray) -> void:
	var info: PlayerTransPacket = PlayerTransPacket.create_from_data(data)
	_rebroad_to_clients(info)

func _rebroad_to_clients(packet: BasePacket) -> void:
	#for id in GrelpNetHandler.client_peers.keys():
		#if id == packet.id and not include_sender: continue
		#packet.send(GrelpNetHandler.client_peers[id])
	packet.broadcast(GrelpNetHandler.connection)

func _handle_gs_player_trans(data: PackedByteArray):
	var info: PlayerTransPacket = PlayerTransPacket.create_from_data(data)
	_update_gs_player(info.id, "pos", info.pos)
	_update_gs_player(info.id, "rot", info.rot)
	# since we changed gamestate
	_rebroad_to_clients(info)
	
func _handle_gs_player_head_trans(data: PackedByteArray):
	var info: PlayerHeadTransPacket = PlayerHeadTransPacket.create_from_data(data)
	_rebroad_to_clients(info)
	
func _handle_gs_player_inv(data: PackedByteArray):
	match data[3]:
		InvPacket.INV_OPT.PICKUP:
			var info: InvPickupPacket = InvPickupPacket.create_from_data(data)
			var inv: Array = _get_gs_player(info.id, "inv")
			if inv.size() >= 3: # we have room
				inv.append(info.item)
				_update_gs_player(info.id, "inv", inv)
				_rebroad_to_clients(info) # only when we change something

func _handle_gs_item_up(data: PackedByteArray):
	var info: ItemPacket = ItemPacket.create_from_data(data)
	match data[3]:
		ItemPacket.ITEM_OPT.SPAWN:
			if info.id == 0: # client spawns but doesn't know id of item till server makes it
				var new_id: int = (len(items.keys()) + 1)
				print("server spawning new item, giving it id: ", new_id)
				Err.push_err_if(new_id > 256, "item ids exceeds 1 integer byte")
				info.id = new_id
			_create_gs_item(info.id, info.pos, info.rot) # this replaces one if thers already one there
			_rebroad_to_clients(info) # only when we change something
		ItemPacket.ITEM_OPT.TRANSFORM: pass
		ItemPacket.ITEM_OPT.DELETE: 
			print("server got item opt del")
			_rm_gs_item(info.id)
			_rebroad_to_clients(info)

# ---- Player ----
# creates a new player and sets it in the players gamestate dict
func _create_gs_player(peer_id: int, health: int, inv_n: int, pos: Vector3, rot: Vector3):
	players[peer_id] = {
		"health": health,
		"inv": range(inv_n),
		"pos": pos,
		"rot": rot
	}

func _rm_gs_player(peer_id: int):
	players.erase(peer_id)

func _update_gs_player(peer_id: int, key: String, val: Variant):
	# there should likely be some checking here to ensure we actually CAN update this GS instead of just blindly doing so
	players[peer_id][key] = val

func _get_gs_player(peer_id: int, key: String) -> Variant:
	return players[peer_id][key]

# ---- Items -----
func _create_gs_item(id: int, pos: Vector3, rot: Vector3):
	items[id] = {
		"pos": pos,
		"rot": rot
	}

func _rm_gs_item(id: int):
	items.erase(id)

func _update_gs_item(id: int, key: String, val: Variant):
	# there should likely be some checking here to ensure we actually CAN update this GS instead of just blindly doing so
	items[id][key] = val

func _get_gs_item(id: int, key: String) -> Variant:
	return items[id][key]

class_name InvPickupPacket extends InvPacket

var item: ResPreloader.ITEM

static func create_pickup(id: int, peer_id: int, item: ResPreloader.ITEM) -> InvPickupPacket:
	var info: InvPickupPacket = InvPickupPacket.new()
	info.packet_type = PACKET_TYPE.INVENTORY
	info.flag = ENetPacketPeer.FLAG_RELIABLE
	info.id = id
	info.peer_id = peer_id
	info.option = INV_OPT.PICKUP
	info.item = item
	return info

static func create_from_data(data: PackedByteArray) -> InvPickupPacket:
	var info: InvPickupPacket = InvPickupPacket.new()
	info.decode(data)
	return info

# [type, player_id, option, item]
func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.encode_u8(4, item)
	data.resize(5)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data) # handled player_id, option, then low level, flag, packettype 
	item = data.decode_u8(4)

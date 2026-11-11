class_name IDPacket extends BasePacket

var id: int
var peer_ids : Array[int]

static func create(id: int, peer_ids: Array[int]) -> IDPacket:
	var info: IDPacket = IDPacket.new()
	info.packet_type = PACKET_TYPE.ID_ASSIGNMENT
	info.flag = ENetPacketPeer.FLAG_RELIABLE # want to use ENet 'tcp'
	info.id = id # peer_id data
	info.peer_ids = peer_ids 
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> IDPacket:
	var info: IDPacket = IDPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(2 + peer_ids.size())
	data.encode_u8(1, id)
	for i in peer_ids .size():
		var id: int = peer_ids[i]
		data.encode_u8(2 + i, id)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	id = data.decode_u8(1)
	for i in range(2, data.size()):
		peer_ids.append(data.decode_u8(i))

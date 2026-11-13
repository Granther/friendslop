class_name InvPacket extends BasePacket

var id: int

enum INV_OPT {
	PICKUP  = 0,
	DROP    = 1,
	RAW_ADD = 2,
	RAW_RMV = 3
}

static func create(id: int, player_id: int, option: INV_OPT) -> InvPacket:
	var info: InvPacket = InvPacket.new()
	info.option = option
	info.id = id
	info.player_id = player_id
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> InvPacket:
	var info: InvPacket = InvPacket.new()
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

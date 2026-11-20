class_name PlayerHeadTransPacket extends BasePacket

# its important these are static because we are calling them on an uninstantiated instance later

var x_rot: float

static func create(peer_id: int, x_rot: float) -> PlayerHeadTransPacket:
	var info: PlayerHeadTransPacket = PlayerHeadTransPacket.new()
	# we have an interesting recursive thing going on here with info, dropping one lower
	info.packet_type = PACKET_TYPE.PLAYER_HEAD_TRANSFORM
	info.flag = ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT 
	info.id = 0
	info.peer_id = peer_id
	info.x_rot = x_rot
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> PlayerHeadTransPacket:
	var info: PlayerHeadTransPacket = PlayerHeadTransPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(MIN_SIZE+4) # (type + id) + 2(4 bytes * 3 floats)
	data.encode_float(MIN_SIZE, x_rot)
	#data.encode_float()
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	x_rot = data.decode_float(MIN_SIZE)

class_name PlayerTransPacket extends BasePacket

# its important these are static because we are calling them on an uninstantiated instance later

var pos: Vector3
var rot: Vector3

static func create(id: int, peer_id: int, pos: Vector3, rot: Vector3) -> PlayerTransPacket:
	var info: PlayerTransPacket = PlayerTransPacket.new()
	# we have an interesting recursive thing going on here with info, dropping one lower
	info.packet_type = PACKET_TYPE.PLAYER_TRANSFORM
	info.flag = ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT 
	info.id = id
	info.peer_id = peer_id
	info.pos = pos # 4 * 3 bytes
	info.rot = rot # 4 * 3 bytes, float is 4 bytes a piece, 3 floats per vec3
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> PlayerTransPacket:
	var info: PlayerTransPacket = PlayerTransPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(3 + (2 * 12)) # (type + id) + 2(4 bytes * 3 floats)
	data.encode_float(3,  pos.x)
	data.encode_float(7,  pos.y)
	data.encode_float(11, pos.z)
	data.encode_float(15, rot.x)
	data.encode_float(19, rot.y)
	data.encode_float(23, rot.z)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	# [type, id, x, y, z, a, b, c]
	pos = Vector3(data.decode_float(3),  data.decode_float(7),  data.decode_float(11))
	rot = Vector3(data.decode_float(15), data.decode_float(19), data.decode_float(23))

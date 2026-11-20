class_name ItemPacket extends BasePacket

# these world packets are just used to moving, spawning, del from the outside world

enum ITEM_OPT { SPAWN, DELETE, TRANSFORM }

var option: ITEM_OPT
var item: ResPreloader.ITEM
var pos: Vector3
var rot: Vector3

static func create(id: int, peer_id: int, option: ITEM_OPT, item: ResPreloader.ITEM, pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> ItemPacket:
	var info: ItemPacket = ItemPacket.new()
	info.packet_type = PACKET_TYPE.ITEM_UPDATE
	info.flag = ENetPacketPeer.FLAG_RELIABLE # want to use ENet 'tcp'
	info.option = option 
	info.item = item
	info.id = id
	info.peer_id = peer_id
	info.pos = pos
	info.rot = rot
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> ItemPacket:
	var info: ItemPacket = ItemPacket.new()
	info.decode(data)
	return info

# pack_t, id, peer_id, option, item
func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(5)
	data.encode_u8(3, option)
	data.encode_u8(4, item)
	if option != ITEM_OPT.DELETE:
		data.resize(5 + (2 * 12))
		data.encode_float(5,  pos.x)
		data.encode_float(9,  pos.y)
		data.encode_float(13, pos.z)
		data.encode_float(17, rot.x)
		data.encode_float(21, rot.y)
		data.encode_float(25, rot.z)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	option = data.decode_u8(3)
	item = data.decode_u8(4)
	if option != ITEM_OPT.DELETE:
		pos = Vector3(data.decode_float(5),  data.decode_float(9),  data.decode_float(13))
		rot = Vector3(data.decode_float(17), data.decode_float(21), data.decode_float(25))
	else: 
		pos = Vector3.ZERO
		rot = Vector3.ZERO

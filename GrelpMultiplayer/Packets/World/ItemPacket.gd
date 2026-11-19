class_name ItemPacket extends BasePacket

# these world packets are just used to moving, spawning, del from the outside world

enum ITEM_OPT { SPAWN, DELETE, TRANSFORM }

var option: ITEM_OPT
var item: ResPreloader.ITEM
var pos: Vector3
var rot: Vector3

static func create(id: int, option: ITEM_OPT, item: ResPreloader.ITEM, pos: Vector3 = Vector3.ZERO, rot: Vector3 = Vector3.ZERO) -> ItemPacket:
	var info: ItemPacket = ItemPacket.new()
	info.packet_type = PACKET_TYPE.ITEM_UPDATE
	info.flag = ENetPacketPeer.FLAG_RELIABLE # want to use ENet 'tcp'
	info.option = option 
	info.item = item
	info.id = id
	info.pos = pos
	info.rot = rot
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> ItemPacket:
	var info: ItemPacket = ItemPacket.new()
	info.decode(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(4)
	data.encode_u8(2, option)
	data.encode_u8(3, item)
	if option != ITEM_OPT.DELETE:
		data.resize(4 + (2 * 12))
		data.encode_float(4,  pos.x)
		data.encode_float(8,  pos.y)
		data.encode_float(12, pos.z)
		data.encode_float(16, rot.x)
		data.encode_float(20, rot.y)
		data.encode_float(24, rot.z)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	option = data.decode_u8(2)
	item = data.decode_u8(3)
	if option != ITEM_OPT.DELETE:
		pos = Vector3(data.decode_float(4),  data.decode_float(8),  data.decode_float(12))
		rot = Vector3(data.decode_float(16), data.decode_float(20), data.decode_float(24))
	else: 
		pos = Vector3.ZERO
		rot = Vector3.ZERO

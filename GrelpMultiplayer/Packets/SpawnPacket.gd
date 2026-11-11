#class_name SpawnPacket extends BasePacket
#
#var id: int
#
#static func create(id: int, pos: Vector3, rot: Vector3) -> PlayerTransPacket:
	#var info: PlayerTransPacket = PlayerTransPacket.new()
	## we have an interesting recursive thing going on here with info, dropping one lower
	#info.packet_type = PACKET_TYPE.PLAYER_TRANSFORM
	#info.flag = ENetPacketPeer.FLAG_UNRELIABLE_FRAGMENT 
	#info.pos = pos # 4 * 3 bytes
	#info.rot = rot # 4 * 3 bytes, float is 4 bytes a piece, 3 floats per vec3
	#info.id = id # unique id of the object
	#return info
#
## unloads into packet
#static func create_from_data(data: PackedByteArray) -> PlayerTransPacket:
	#var info: PlayerTransPacket = PlayerTransPacket.new()
	#info.decode(data)
	#return info
#
#func encode() -> PackedByteArray:
	#var data: PackedByteArray = super.encode()
	#data.resize(2 + (2 * 12)) # (type + id) + 2(4 bytes * 3 floats)
	#data.encode_u8(1, id)
	#data.encode_float(2,  pos.x)
	#data.encode_float(6,  pos.y)
	#data.encode_float(10, pos.z)
	#data.encode_float(14, rot.x)
	#data.encode_float(18, rot.y)
	#data.encode_float(22, rot.z)
	#return data
#
#func decode(data: PackedByteArray) -> void:
	#super.decode(data)
	#id = data.decode_u8(1) # [type, id, x, y, z, a, b, c]
	#pos = Vector3(data.decode_float(2),  data.decode_float(6),  data.decode_float(10))
	#rot = Vector3(data.decode_float(14), data.decode_float(18), data.decode_float(22))

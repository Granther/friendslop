class_name BasePacket

# Don't make values above 255, since we send "packet_type" as a single byte
enum PACKET_TYPE {
	ID_ASSIGNMENT,
	PLAYER_TRANSFORM,
	PLAYER_HEAD_TRANSFORM,
	INVENTORY,
	ITEM_UPDATE,
}

const MIN_SIZE = 3

var packet_type: PACKET_TYPE
var flag: int
var peer_id: int # player that sent the packet, I think we need this
var id: int 

# Override function in derived classes
func encode() -> PackedByteArray:
	var data: PackedByteArray
	data.resize(MIN_SIZE)
	data.encode_u8(0, packet_type)
	data.encode_u8(1, id)
	data.encode_u8(2, peer_id)
	return data

# Override function in derived classes
func decode(data: PackedByteArray) -> void:
	# this is just setting up the type for the base class on all childre
	# this is why we call super.decode etc, its common
	packet_type = data.decode_u8(0)
	id = data.decode_u8(1)
	peer_id = data.decode_u8(2)

func send(target: ENetPacketPeer) -> void:
	target.send(0, encode(), flag)

# only works on server duh
func broadcast(server: ENetConnection) -> void:
	server.broadcast(0, encode(), flag)

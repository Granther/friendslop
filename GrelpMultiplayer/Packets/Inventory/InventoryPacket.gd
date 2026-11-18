class_name InvPacket extends BasePacket

enum INV_OPT {
	PICKUP  = 0,
	DROP    = 1,
	RAW_ADD = 2,
	RAW_RMV = 3
}

var option: int
var player_id: int

static func create(player_id: int, option: INV_OPT) -> InvPacket:
	var info: InvPacket = InvPacket.new()
	info.option = option
	info.player_id = player_id
	return info

# unloads into packet
static func create_from_data(data: PackedByteArray) -> InvPacket:
	var info: InvPacket = InvPacket.new()
	info.decode(data)
	match info.option: # this does feel a little jank, but it works for keeping the extra dat from inv option after boucing from server back to other clients
		INV_OPT.PICKUP:
			return InvPickupPacket.create_from_data(data)
	return info

func encode() -> PackedByteArray:
	var data: PackedByteArray = super.encode()
	data.resize(6) # we make this is largest of all options, then resize in derived
	data.encode_u8(1, player_id)
	data.encode_u8(2, option)
	return data

func decode(data: PackedByteArray) -> void:
	super.decode(data)
	player_id = data.decode_u8(1)
	option = data.decode_u8(2)

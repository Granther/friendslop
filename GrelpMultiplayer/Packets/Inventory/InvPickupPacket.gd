class_name InvPickupPacket extends InvPacket

static func create_pickup(id: int, player_id: int, item: ResPreloader.ITEM) -> InvPickupPacket:
	var info: InvPickupPacket = super.create(id, player_id, INV_OPT.PICKUP)
	info.item = item
	return info

static func create_from_data(data: PackedByteArray) -> InvPickupPacket:
	var info: InvPickupPacket = InvPickupPacket.new()
	info.decode(data)
	return info

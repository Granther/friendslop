class_name BaseWorld extends Node3D

# we always need to spawn into a world, so, it should always be able to offer us a spawnpoint

@export var spawnpoint_comp: SpawnpointComponent

# im ok with this being in baseworld and not worldapi since items have to be moved between worlds
var items: Dictionary

func _ready() -> void:
	MultiplayerApi.item_updated.connect(_item_updated)
	
	Err.push_err_if(not self.has_node("MultiplayerSpawner"), "every world must have a multiplayer spawner")
	Err.push_err_if(spawnpoint_comp == null, "every world must have at least one spawnpoint")

# we cab use this to spawn other players in the world from another
func get_spawnpoint_comp() -> SpawnpointComponent:
	return spawnpoint_comp

func spawn_ctrl_player(peer_id: int) -> void:
	spawnpoint_comp.spawn_ctrl_player(peer_id)

func spawn_peer_player(peer_id: int) -> void:
	spawnpoint_comp.spawn_peer_player(peer_id)

func _item_updated(item_id: int, peer_id: int, item: ResPreloader.ITEM, option: ItemPacket.ITEM_OPT, pos: Vector3, rot: Vector3):
	match option:
		ItemPacket.ITEM_OPT.SPAWN:
			if MultiplayerApi.peer_id == peer_id: 
				_update_item_id(item_id, item)
			else: spawn_item_loc(item_id, peer_id, item, pos, rot)
		ItemPacket.ITEM_OPT.DELETE: 
			if MultiplayerApi.peer_id == peer_id: return
			else: delete_item_loc(item_id)
		ItemPacket.ITEM_OPT.TRANSFORM: 
			var inst: Node3D = items.get(item_id)
			if inst == null: return
			inst.global_position = pos
			inst.global_rotation = rot

func delete_item_loc(item_id: int):
	var inst: Node3D = items.get(item_id)
	if inst == null: return
	remove_child(inst)
	inst.queue_free()

# should await_id_from_srv if spawned manually, when bounces back, will get correct id
# this measn the id should also be 
# if peer_id == multiplayer.peer_id, we already spawned it, jst need to update id

func spawn_item_loc(item_id: int, peer_id: int, item: ResPreloader.ITEM, pos: Vector3, rot: Vector3):
	var item_scn: PackedScene = ResPreloader.items_dict[item]
	var inst: InvEquip = item_scn.instantiate() # is this in the heirarchy yet? onot?
	inst.id = item_id
	add_child(inst) # first we add as a child, cause these are then set thesethey are relative
	items[item_id] = inst
	inst.global_position = pos
	inst.global_rotation = rot

func _update_item_id(new_item_id: int, item: ResPreloader.ITEM):
	var inst: InvEquip = items.get(0)
	if inst == null: return
	if inst.type == item:
		inst.id = new_item_id
		items.erase(0)
		items[new_item_id] = inst
	else:
		Err.push_err_if(true, "got item id update but for the wrong item type")

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

func _item_updated(item_id: int, item: ResPreloader.ITEM, option: ItemPacket.ITEM_OPT, pos: Vector3, rot: Vector3):
	match option:
		ItemPacket.ITEM_OPT.SPAWN:
			var item_scn: PackedScene = ResPreloader.items_dict[item]
			var inst: Node3D = item_scn.instantiate() # is this in the heirarchy yet? or not?
			inst.id = item_id
			add_child(inst) # first we add as a child, cause these are then set these, they are relative
			items[item_id] = inst
			inst.global_position = pos
			inst.global_rotation = rot
		ItemPacket.ITEM_OPT.DELETE: 
			print("got delete from client")
			var inst: Node3D = items.get(item_id)
			print(inst, item_id)
			if null: return
			remove_child(inst)
			inst.queue_free()
		ItemPacket.ITEM_OPT.TRANSFORM: 
			var inst: Node3D = items.get(item_id)
			if null: return
			inst.global_position = pos
			inst.global_rotation = rot

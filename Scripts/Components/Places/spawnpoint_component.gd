class_name SpawnpointComponent extends BaseComponent

# as it stands, the level component simply just allows for a spawnpoint for a level

@export var multiplayer_spawner: MultiplayerSpawner
@export var player_scene: PackedScene
# we expect root_obj to be a scene 

func _ready():
	if not multiplayer_spawner:
		multiplayer_spawner = Utils.find_node_cur_world("MultiplayerSpawner")
	Err.push_err_if(player_scene == null, "must pass player scene to spawnpoint component")

# lets call this while in the old world
func move_player(player: Node):
	#foo.rpc(player.get_path())
	MultiplayerApi.my_player.reparent(root_obj)
	_spawn_at_spawnpoint_loc.rpc(player.get_path())

#@rpc("call_local", "any_peer")
#func foo(p: NodePath): 
	#get_node(p).reparent(root_obj)

func spawn_new_player(peer_id: int):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	#MultiplayerApi.add_player(player, peer_id)
	#MultiplayerApi.my_peer_id = peer_id
	print("setting my_player for ", str(peer_id))
	MultiplayerApi.my_player = player
	root_obj.add_child(player) # this trigger multiplayer spawner to sync
	_spawn_at_spawnpoint_loc.rpc(player.get_path())

# every player has authority over themselves, so they must each move themselves
@rpc("call_local", "any_peer")
func _spawn_at_spawnpoint_loc(player_path: NodePath):
	var player = get_node(player_path)
	player.global_position = self.global_position

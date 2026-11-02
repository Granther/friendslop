class_name SpawnpointComponent extends BaseComponent

# as it stands, the level component simply just allows for a spawnpoint for a level

@export var multiplayer_spawner: MultiplayerSpawner
@export var player_scene: PackedScene

# we expect root_obj to be a scene 

func _ready():
	if not multiplayer_spawner:
		multiplayer_spawner = Utils.find_node_cur_world("MultiplayerSpawner")
	Err.push_err_if(player_scene == null, "must pass player scene to spawnpoint component")
	MultiplayerConnectionHandler.connected_new_player.connect(_setup_player)

func spawn_player(player_path: NodePath, new_parent: Node, spawn_marker: Marker3D):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	root_obj.add_child(player) # this trigger multiplayer spawner to sync
	_spawn_at_spawnpoint.rpc(player.get_path())

# every player has authority over themselves, so they must each move themselves
@rpc("call_local", "any_peer")
func _spawn_at_spawnpoint(player_path: NodePath, spawn_loc: Vector3):
	var player = get_node(player_path)
	player.global_position = spawn_loc

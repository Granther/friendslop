class_name LevelComponent extends BaseComponent

# as it stands, the level component simply just allows for a spawnpoint for a level

@export var multiplayer_spawner: MultiplayerSpawner

# we expect root_obj to be a scene 

const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready():
	MultiplayerConnectionHandler.connected_new_player.connect(_setup_player)

func _setup_player(peer_id: int):
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	root_obj.add_child(player) # this trigger multiplayer spawner to sync
	_spawn_at_spawnpoint.rpc(player.get_path())

# every player has authority over themselves, so they must each move themselves
@rpc("call_local", "any_peer")
func _spawn_at_spawnpoint(player_path: NodePath):
	var player = get_node(player_path)
	player.global_position = root_obj.spawn_loc.global_position

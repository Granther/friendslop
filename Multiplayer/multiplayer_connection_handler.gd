# MultiplayerConnectionHandler
# Singleton used to interact with the multiplayer backend via the UI

# Instantiate, we are "starting" the world before we load it
extends Node

const Player = preload("res://Scenes/Player/player.tscn")

var chosen_scene: PackedScene = preload("res://Scenes/Places/world.tscn")
var player: CharacterBody3D = null

func _ready():
	WorldAPI.set_world(chosen_scene.instantiate())

func local_multiplayer_a():
	var status = LocalMultiplayerHandler.start_server()
	if status == LocalMultiplayerHandler.IS_SERVER:
		_setup_peer_host_signals()
		add_player(get_tree().get_multiplayer().get_unique_id())
		
func remote_multiplayer_join_a(room_id: String):
	await RemoteMultiplayerHandler.start_client(room_id)

func remote_multiplayer_host_a() -> String:
	var room_id: String = await RemoteMultiplayerHandler.start_server()
	_setup_peer_host_signals()
	add_player(get_tree().get_multiplayer().get_unique_id())
	return room_id

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	WorldAPI.get_world().add_child(player)
	print("added player: ", peer_id)
	
func remove_player(peer_id):
	WorldAPI.get_world().remove_child(WorldAPI.get_world().get_node(str(peer_id)))

func peer_connected(peer_id: int):
	add_player(peer_id)

# I think we want to call this on the server somehow, but, also on all clients to remove the specific player
func peer_disconnected(peer_id: int):
	remove_player(peer_id)

func _setup_peer_host_signals():
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)

extends Node3D

@onready var spawn_loc: Marker3D = $SpawnLocation
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready() -> void:
	multiplayer_spawner.spawn_function = _spawn_new_player
	MultiplayerConnectionHandler.connected_new_player.connect(_spawn)

func _spawn_new_player(peer_id: int) -> Node:
	print(multiplayer.get_unique_id())
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	self.add_child(player)
	player.global_position = spawn_loc.global_position
	return player

func _spawn(peer_id: int):
	if not multiplayer.is_server(): return
	multiplayer_spawner.spawn(peer_id)
	
func setup_player(peer_id: int):
	print("here")
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	self.add_child(player)
	player.global_position = spawn_loc.global_position
	print("at pos")

#func _move_to_spawn_point(p: CharacterBody3D):
	#print("riun")
	#p.global_position = spawn_loc.global_position

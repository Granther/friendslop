extends Node3D

@onready var spawn_loc: Marker3D = $SpawnLocation
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready() -> void:
	pass
	#MultiplayerConnectionHandler.spawned_player.connect(_move_to_spawn_point)
#

func setup_player(peer_id: int):
	print("here")
	var player = player_scene.instantiate()
	player.name = str(peer_id)
	self.add_child(player)
	player.global_position = spawn_loc.global_position

#func _move_to_spawn_point(p: CharacterBody3D):
	#print("riun")
	#p.global_position = spawn_loc.global_position

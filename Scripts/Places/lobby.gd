extends Node3D

@onready var spawn_loc: Marker3D = $SpawnLocation
@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner

const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready() -> void:
	pass

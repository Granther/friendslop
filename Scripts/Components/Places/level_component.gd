class_name LevelComponent extends BaseComponent

# as it stands, the level component simply just allows for a spawnpoint for a level

@export var multiplayer_spawner: MultiplayerSpawner

# we expect root_obj to be a scene 

const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready():
	MultiplayerConnectionHandler.connected_new_player.connect(_setup_player)

func _setup_player(peer_id: int):
	pass

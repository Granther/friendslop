extends Node

#var chosen_scene = preload("res://Scenes/Places/world_flat.tscn")
const chosen_scene = preload("res://Scenes/Places/lobby.tscn")
const player_scene = preload("res://Scenes/Player/player.tscn")

func _ready() -> void:
	var scene_inst = chosen_scene.instantiate()
	WorldAPI.set_world(scene_inst)
	add_child(scene_inst)
	
	MultiplayerConnectionHandler.connected_new_player.connect(_setup_new_player)

func _setup_new_player(peer_id: int):
	#print("here")
	#var player = player_scene.instantiate()
	#player.name = str(peer_id)
	WorldAPI.get_world().setup_player(peer_id)
	#player.global_position = WorldAPI.get_world().spawn_loc.global_position

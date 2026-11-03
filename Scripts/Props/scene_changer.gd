extends CSGBox3D

@onready var hover_icomp: HoverInteractComponent = $HoverInteractComponent

const new_scene = preload("res://Scenes/Places/world.tscn")

func _ready() -> void:
	hover_icomp.interact_func = _switch_scenes
	
func _switch_scenes(interactor: Node) -> void:
	#print("switching scene from ", str(MultiplayerApi.my_peer_id))
	#print(MultiplayerApi.get_players())
	var new = new_scene.instantiate()
	var new_spawnpoint = new.get_spawnpoint_comp()
	var old_level = WorldAPI.get_world()
	WorldAPI.level_parent.add_child(new)
	#for id in MultiplayerApi.get_players():
		#var p = MultiplayerApi.get_player_by_peer_id(id)
		#print(p)
	#var p = MultiplayerApi.get_player_by_peer_id(MultiplayerApi.my_peer_id)
	new_spawnpoint.move_player(MultiplayerApi.my_player)
	old_level.queue_free()
	WorldAPI.set_world(new)

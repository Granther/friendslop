extends Node

var chosen_scene = preload("res://Scenes/Places/world.tscn")

func _ready() -> void:
	var scene_inst = chosen_scene.instantiate()
	WorldAPI.set_world(scene_inst)
	add_child(scene_inst)

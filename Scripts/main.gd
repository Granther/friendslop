extends Node

#const chosen_scene = preload("res://Scenes/Places/lobby.tscn")
@export var chosen_scene: PackedScene

func _ready() -> void:
	var scene_inst = chosen_scene.instantiate()
	WorldAPI.set_world(scene_inst)
	add_child(scene_inst)

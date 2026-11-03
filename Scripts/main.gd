extends Node

#const chosen_scene = preload("res://Scenes/Places/lobby.tscn")
@export var chosen_scene: PackedScene

@onready var level_parent := $level_parent

func _ready() -> void:
	WorldAPI.level_parent = level_parent
	var scene_inst = chosen_scene.instantiate()
	WorldAPI.set_world(scene_inst)
	level_parent.add_child(scene_inst)

class_name BaseComponent extends Node

@export var root_obj: Node3D

func _ready() -> void:
	# Just in case I get forgetful...
	if root_obj == null:
		root_obj = get_parent()

func get_root_obj() -> Node3D:
	return root_obj

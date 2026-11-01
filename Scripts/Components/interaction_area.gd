class_name InteractionArea
extends Area3D

func get_root_obj() -> Node3D:
	return get_parent().get_parent()

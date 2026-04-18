extends Node

# Used as singleton to allow all other nodes to access the root of the current world scene

var current_world: Node3D

func set_world(new_world: Node3D):
	current_world = new_world
	
func get_world() -> Node3D:
	return current_world

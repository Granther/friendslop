extends Node

# Used as singleton to allow all other nodes to access the root of the current world scene

var current_world: BaseWorld

var level_parent: Node3D = null

func set_world(new_world: BaseWorld):
	current_world = new_world
	
func get_world() -> BaseWorld:
	return current_world

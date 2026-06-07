extends Node3D
class_name PlayerComponent

@export var player_ref: CharacterBody3D

var NULL_FUNC = func(): pass

# Called by player in respective phys and proc funcs
var phys_func = func(): pass
var proc_func = func(): pass

func _ready():
	if player_ref == null:
		player_ref = get_parent()
		Err.push_warn_if(player_ref == null, "player_ref exported var musn't be null for Component")

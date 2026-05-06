extends Node
class_name PlayerComponent

@export var player_ref: CharacterBody3D

var NULL_FUNC = func(): pass

# Called by player in respective phys and proc funcs
var phys_func = func(): pass
var proc_func = func(): pass

func _ready():
	Err.push_err_if(player_ref == null, "player_ref exported var musn't be null for Component")

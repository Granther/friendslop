extends Node3D

# Handles the physical system that is the player. Moving hand to marker 3d

@onready var holding_marker = %HoldingMarker

@export var player_ref: CharacterBody3D

var phys_func = func(): pass
var proc_func = func(): pass

func _process(delta: float) -> void:
	proc_func.call()

func set_hand_to_hold():
	print("hiy")
	print(player_ref.right_arm.position, holding_marker.position)
	player_ref.right_arm.global_position = holding_marker.global_position
	print(player_ref.right_arm.position, holding_marker.position)
	
func reset_hand():
	player_ref.right_arm.position = Vector3.ZERO

extends Node3D

# Handles the physical system that is the player. Moving hand to marker 3d
# Managing animations

@onready var holding_marker = %HoldingMarker

@export var player_ref: CharacterBody3D

@onready var hip_hold_marker: Marker3D = %HipHoldMarker
@onready var center_hold_marker: Marker3D = %CenterHoldMarker
@onready var item_anchor: Marker3D = %ItemGrabAnchor

var phys_func = func(): pass
var proc_func = func(): pass

func _process(delta: float) -> void:
	proc_func.call()

func set_hand_to_hold():
	proc_func = func():
		player_ref.right_arm.global_position = hip_hold_marker.global_position
	
func reset_hand():
	player_ref.right_arm.position = Vector3.ZERO
	proc_func = func(): pass

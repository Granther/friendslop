extends Node3D

# This module deals with interacting with things that are "global"
# Ie. they are not on the player and are to be taken in and processes
# outside -> player

# ItemManager
# Takes items/interactions given to it be the scanner and manages them
# outside -> player -> holds -> 

signal interacted_external_item(item: Node3D)
signal drop_item

var can_interact: bool = true
var interactables: Array[Node3D]

@export var player_ref: CharacterBody3D
@export var object_shape_cast: ShapeCast3D

# Could we always be sorting the list to be the closest object at the front?
# Probably too much compute

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is InteractionArea:
		area.set_label_visible(true)
		interactables.append(area.get_root_obj())

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area is InteractionArea:
		area.set_label_visible(false)
		interactables.erase(area.get_root_obj())

# interactables.sort_custom(_sort_by_distance_to_player)
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = global_position.distance_to(area1.global_position)
	var area2_to_player = global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _allow_interaction():
	can_interact = true

# Should some signal fire here from the item_manager to scoop up the object and handle it from there?
func _input(event):
	if event.is_action_pressed("interact1"):
		if can_interact and len(interactables) > 0 and object_shape_cast.is_colliding():
			var object_collided = object_shape_cast.get_collision_result()[0]["collider"]
			if object_collided in interactables:
				can_interact = false
				get_viewport().set_input_as_handled()
				emit_signal("interacted_external_item", object_collided)

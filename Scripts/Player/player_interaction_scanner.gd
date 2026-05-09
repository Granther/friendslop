extends PlayerComponent

# This module deals with interacting with things that are "global"
# Ie. they are not on the player and are to be taken in and processes
# outside -> player

# ItemManager
# Takes items/interactions given to it be the scanner and manages them
# outside -> player -> holds -> 

# Outputs
signal interacted_external_item(item: InteractComponent) # -> ItemManager

# Listens
# ItemManager:signal -> _allow_interaction

var can_interact: bool = true
var interactables: Array[Node3D]

# Could we always be sorting the list to be the closest object at the front?
# Probably too much compute

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area is InteractionArea:
		# area.set_label_visible(true)
		interactables.append(area.get_root_obj())

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area is InteractionArea:
		# area.set_label_visible(false)
		interactables.erase(area.get_root_obj())

# interactables.sort_custom(_sort_by_distance_to_player)
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player_ref.global_position.distance_to(area1.global_position)
	var area2_to_player = player_ref.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _allow_interaction():
	can_interact = true

# Should some signal fire here from the item_manager to scoop up the object and handle it from there?
func _input(event):
	if event.is_action_pressed("interact1"):
		if can_interact and len(interactables) > 0 and player_ref.object_grabber_shape_cast.is_colliding():
			var object_collided = player_ref.object_grabber_shape_cast.get_collision_result()[0]["collider"]
			#if (object_collided is Interactable) and (object_collided in interactables):
			if (object_collided.has_node("InteractComponent")) and (object_collided in interactables):
				can_interact = false
				var object_interact_comp = object_collided.get_node("InteractComponent")
				# Here! We should see if we are interacting with item or vehicle, cause those are separate
				# This erases the "interact" input, so it doesn't get passed to the item
				get_viewport().set_input_as_handled()
				interacted_external_item.emit(object_interact_comp)

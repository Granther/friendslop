extends Node3D

signal interacted_external_item(item: Node3D)
signal drop_item

var can_interact: bool = true
var interactables: Array[Node3D]

@export var root_player: CharacterBody3D
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

# Should some signal fire here from the item_manager to scoop up the object and handle it from there?
func _input(event):
	# This kind of assumes pick up
	if event.is_action_pressed("interact1"):
		if can_interact and len(interactables) > 0 and object_shape_cast.is_colliding():
			var object_collided = object_shape_cast.get_collision_result()[0]["collider"]
			if object_collided in interactables:
				print("Fired: interacted w/ external item")
				emit_signal("interacted_external_item", object_collided)
	elif event.is_action_pressed("drop"):
		emit_signal("drop_item")
		

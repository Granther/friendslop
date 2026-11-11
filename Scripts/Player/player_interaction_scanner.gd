extends PlayerComponent

# This module deals with interacting with things that are "global"
# Ie. they are not on the player and are to be taken in and processes
# outside -> player

# ItemManager
# Takes items/interactions given to it be the scanner and manages them
# outside -> player -> holds -> 

# Outputs
signal interacted_external_item(item: InteractComponent) # -> ItemManager
signal looking_interactable_changed(looking: bool) # -> HUDManager

# Listens
# ItemManager:signal -> _allow_interaction

var _can_ride: bool = true
var _can_grab: bool = true
var _looking_at_inter: bool = false
var _interactables: Array[Node3D]

# Could we always be sorting the list to be the closest object at the front?
# Probably too much compute

func _ready():
	proc_func = _proc_func

# the architecture is that all things that the player can interact with are in this list
# why? well, not everything on a layer may be interactable

#func _on_area_3d_area_entered(area: Area3D) -> void:
	#if area is InteractionArea:
		## area.set_label_visible(true)
		#_interactables.append(area.get_root_obj())
#
#func _on_area_3d_area_exited(area: Area3D) -> void:
	#if area is InteractionArea:
		## area.set_label_visible(false)
		#_interactables.erase(area.get_root_obj())
#
## interactables.sort_custom(_sort_by_distance_to_player)
#func _sort_by_distance_to_player(area1, area2):
	#var area1_to_player = player_ref.global_position.distance_to(area1.global_position)
	#var area2_to_player = player_ref.global_position.distance_to(area2.global_position)
	#return area1_to_player < area2_to_player

func _allow_grab():
	_can_grab = true

func _allow_ride():
	_can_ride = true

# Should some signal fire here from the item_manager to scoop up the object and handle it from there?
func _input(event):
	if event.is_action_pressed("interact1"):
		if _looking_at_inter:
			# give object, any, that it hits 
			var object_collided = player_ref.object_grab_raycast.get_collider()
			var obj_inter_comp: InteractComponent
			# check if we actually can interact before even seeing if the thing can be
			if object_collided.has_node("HoverInteractComponent"):
				obj_inter_comp = object_collided.get_node("HoverInteractComponent")
			elif _can_grab:
				if object_collided.has_node("GrabComponent"):
					obj_inter_comp = object_collided.get_node("GrabComponent")
					_can_grab = false
				elif object_collided.has_node("PushComponent"):
					obj_inter_comp = object_collided.get_node("PushComponent")
					_can_grab = false
			elif _can_ride:
				if object_collided.has_node("RideComponent"):
					obj_inter_comp = object_collided.get_node("RideComponent")
					_can_ride = false
			# why is this here? i forgor
			# this means that we catch the input, it wont propagate anymore
			get_viewport().set_input_as_handled()
			if obj_inter_comp != null: # ensure we actually habe an object
				interacted_external_item.emit(obj_inter_comp)
			else: return # nothing happens, the interact was attempted but nothing happened

func _set_looking_state():
	if player_ref.object_grab_raycast.is_colliding():
		if _looking_at_inter: pass
		elif not _looking_at_inter:
			_looking_at_inter = true
			looking_interactable_changed.emit(true)
	else:
		if _looking_at_inter: 
			_looking_at_inter = false
			looking_interactable_changed.emit(false) 
		elif not _looking_at_inter: pass 

func _proc_func() -> void:
	_set_looking_state()

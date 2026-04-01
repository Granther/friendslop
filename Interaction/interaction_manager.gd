extends Node3D

@onready var player = get_tree().get_first_node_in_group("player")

const base_text = "[E] to "

var active_areas = []
var can_interact = true
var label: Label3D

func register_area(area: InteractionArea, lab: Label3D):
	label = lab
	active_areas.push_back(area)
	
func unregister_area(area: InteractionArea):
	label.hide()
	label = null
	var index = active_areas.find(area)
	if index != -1: # Returns -1, if it can't find it
		active_areas.remove_at(index)

func _process(delta):
	if label == null: return
	# Ie, we are actually in an area 
	if active_areas.size() > 0 and can_interact:
		# I imagine that sort_custom plugs in 2 items and condtionally operates on the one returned
		active_areas.sort_custom(_sort_by_distance_to_player)
		# active_name obvo
		# Since we sorted, putting the smallest at the beg, we simply get the first, the closest
		label.text = base_text + active_areas[0].action_name
		# Set the position of the label to where the interacable area is
		# label.global_position = active_areas[0].global_position
		#label.global_position -= 36
		#label.global_position.x -= label.size.x / 2
		label.show()
	else:
		# Otherwise hide
		label.hide()

func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player
	
func _input(event):
	if event.is_action_pressed("interact1") and can_interact:
		if active_areas.size() > 0: # Disable interaction so we cant w/ anything else
			can_interact = false
			label.hide()
			
			# Call interactable Callable
			await active_areas[0].interact.call()
			can_interact = true

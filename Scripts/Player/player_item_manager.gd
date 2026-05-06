extends Node3D

# Player Item Manager
# Keeps track of player's items that are currently in their hand

# We should have some very specific set of rules, a protocol, for handling reg and dereg

# Interact with i, we, the player, call some 

signal grabbed_item(item: Node3D)
signal dropped_item
signal done_interacting

signal drop_key_hit
signal leftm_key_hit
signal rightm_key_hit
signal interact_key_hit

var cur_item: Interactable = null
var cur_ridable: Interactable = null
var holding_item: bool = false

@export var player_ref: CharacterBody3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		drop_key_hit.emit()
	if event.is_action_pressed("interact1"):
		interact_key_hit.emit()
	if event.is_action_pressed("left_mouse"):
		leftm_key_hit.emit()
	if event.is_action_pressed("right_mouse"):
		rightm_key_hit.emit()

func _on_int_scan_interacted_external_item(item: RigidBody3D) -> void:
	item.item_comp.register(player_ref)
	
	if item is Rideable:
		if not on_ridable():
			cur_ridable = item
			register_key_connects()
			ride()
	elif item is Grabbable:
		if not has_item():
			cur_item = item
			register_key_connects()
			grab_item()
	else:
		push_error("item is not interactable, but not found to be specific: ", item.name)
		done_interacting.emit()

func register_key_connects():
	drop_key_hit.connect(cur_item.item_comp.on_drop_key_hit)
	leftm_key_hit.connect(cur_item.item_comp.on_leftm_key_hit)
	rightm_key_hit.connect(cur_item.item_comp.on_rightm_key_hit)
	interact_key_hit.connect(cur_item.item_comp.on_inter_key_hit)

func deregister_key_connects():
	drop_key_hit.disconnect(cur_item.item_comp.on_drop_key_hit)
	leftm_key_hit.disconnect(cur_item.item_comp.on_leftm_key_hit)
	rightm_key_hit.disconnect(cur_item.item_comp.on_rightm_key_hit)
	interact_key_hit.disconnect(cur_item.item_comp.on_inter_key_hit)

func grab_item():
	cur_item.reparent(player_ref.camera)
	grabbed_item.emit(cur_item)
	player_ref.body_manager.set_hand_to_hold()

func ride(): pass

func _deregister_item():
	# cur_item.item_comp.deregister()
	deregister_key_connects()
	cur_item = null
	dropped_item.emit()
	done_interacting.emit()

func drop_item():
	cur_item.reparent(WorldAPI.get_world())
	player_ref.body_manager.reset_hand()
	_deregister_item()

#func remove_item():
	#_deregister_item()

func has_item() -> bool:
	return (cur_item != null)
	
func on_ridable() -> bool:
	return (cur_ridable != null)

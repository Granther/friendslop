extends Component

# Player Item Manager
# Keeps track of player's items that are currently in their hand

# We should have some very specific set of rules, a protocol, for handling reg and dereg

# Interact with i, we, the player, call some 

# Outputs
signal allow_interaction # -> InteractionScanner
signal grabbed_item      # -> BodyHandler
signal dropped_item      # -> BodyHandler
signal entered_ride      # -> BodyHandler
signal exited_ride       # -> BodyHandler

# Listens
# InteractionScanner:signal -> interacted_external_item

signal drop_key_hit
signal leftm_key_hit
signal rightm_key_hit
signal interact_key_hit

var cur_grab: Interactable = null
var cur_ride: Interactable = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		drop_key_hit.emit()
	if event.is_action_pressed("interact1"):
		interact_key_hit.emit()
	if event.is_action_pressed("left_mouse"):
		leftm_key_hit.emit()
	if event.is_action_pressed("right_mouse"):
		rightm_key_hit.emit()

func _on_int_scan_interacted_external_item(item: Interactable) -> void:
	item.item_comp.register(player_ref)
	
	if item is Rideable:
		if not is_ride():
			cur_ride = item
			register_key_connects()
			ride()
	elif item is Grabbable:
		if not is_grab():
			cur_grab = item
			_register_grab()
			register_key_connects()
			grab_item()
	else:
		push_error("item is not interactable, but not found to be specific: ", item.name)
		allow_interaction.emit()

func register_key_connects():
	drop_key_hit.connect(cur_grab.item_comp.on_drop_key_hit)
	leftm_key_hit.connect(cur_grab.item_comp.on_leftm_key_hit)
	rightm_key_hit.connect(cur_grab.item_comp.on_rightm_key_hit)
	interact_key_hit.connect(cur_grab.item_comp.on_inter_key_hit)

func deregister_key_connects():
	drop_key_hit.disconnect(cur_grab.item_comp.on_drop_key_hit)
	leftm_key_hit.disconnect(cur_grab.item_comp.on_leftm_key_hit)
	rightm_key_hit.disconnect(cur_grab.item_comp.on_rightm_key_hit)
	interact_key_hit.disconnect(cur_grab.item_comp.on_inter_key_hit)

func grab_item():
	cur_grab.reparent(player_ref.camera)
	grabbed_item.emit(cur_grab)
	player_ref.body_manager.set_hand_to_hold()

func ride(): pass

func _register_grab():
	cur_grab.reparent(player_ref.camera)
	grabbed_item.emit()

func _deregister_grab():
	# cur_grab.item_comp.deregister()
	# deregister_key_connects()
	cur_grab = null
	allow_interaction.emit()
	dropped_item.emit()

func drop_item():
	cur_grab.reparent(WorldAPI.get_world())
	player_ref.body_manager.reset_hand()
	# _deregister_item()

func is_grab() -> bool:
	return (cur_grab != null)
	
func is_ride() -> bool:
	return (cur_ride != null)

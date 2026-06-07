extends PlayerComponent

# Player Item Manager
# Keeps track of player's items that are currently in their hand

# We should have some very specific set of rules, a protocol, for handling reg and dereg

# Interact with i, we, the player, call some 

# Outputs
signal allow_interaction # -> InteractionScanner
signal grabbed_item      # -> BodyHandler
signal dropped_item      # -> BodyHandler
signal entered_ride(phys_func: Callable)      # -> BodyHandler
signal exited_ride       # -> BodyHandler

# Listens
# InteractionScanner:signal -> interacted_external_item

signal drop_key_hit
signal leftm_key_hit
signal rightm_key_hit
signal interact_key_hit

# These are the interact components OF THE ITEM, not the item. We don't touch the item, thats the beautiful part :>
var cur_grab: InteractComponent = null
var cur_ride: InteractComponent = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		if is_grab(): _deregister_grab()
	if event.is_action_pressed("interact1"):
		interact_key_hit.emit()
	if event.is_action_pressed("left_mouse"):
		leftm_key_hit.emit()
	if event.is_action_pressed("right_mouse"):
		rightm_key_hit.emit()
	if event.is_action_released("crouch"):
		if is_ride(): _deregister_ride()

# Grabbable is an interactable 
func _on_int_scan_interacted_external_item(inter: InteractComponent) -> void:
	if inter is RideComponent:
		cur_ride = inter
		_register_ride()
	elif inter is GrabComponent:
		cur_grab = inter
		_register_grab()
	else:
		push_error("item is not interactable, but not found to be specific: ", inter.name)
		allow_interaction.emit()

func _register_ride(): 
	if not is_ride(): return
	_set_auth_and_distrib.rpc(cur_ride.get_root_obj().get_path(), multiplayer.get_unique_id())
	cur_ride.register(player_ref)
	entered_ride.emit(cur_ride.phys_movement_func)

func _deregister_ride():
	if not is_ride(): return
	_set_auth_and_distrib.rpc(cur_ride.get_root_obj().get_path()) # Return control to server
	cur_ride.deregister(player_ref)
	exited_ride.emit()
	cur_ride = null

func _register_grab():
	if not is_grab(): return
	cur_grab.register(player_ref.camera, player_ref.right_hand_obj_marker)
	_register_key_connects(cur_grab)
	_register_force_connects(cur_grab)
	grabbed_item.emit()

func _deregister_grab():
	if not is_grab(): return
	_deregister_key_connects(cur_grab)
	_deregister_force_connects(cur_grab)
	cur_grab.deregister()
	allow_interaction.emit()
	dropped_item.emit()
	cur_grab = null

@rpc("call_local")
func _set_auth_and_distrib(thing_p: NodePath, new_auth: int = 1):
	get_node(thing_p).set_multiplayer_authority(new_auth)

func is_grab() -> bool:
	return (cur_grab != null)
	
func is_ride() -> bool:
	return (cur_ride != null)

func _register_key_connects(inter: InteractComponent):
	leftm_key_hit.connect(inter.on_leftm_key_hit)
	rightm_key_hit.connect(inter.on_rightm_key_hit)
	interact_key_hit.connect(inter.on_inter_key_hit)

func _deregister_key_connects(inter: InteractComponent):
	leftm_key_hit.disconnect(inter.on_leftm_key_hit)
	rightm_key_hit.disconnect(inter.on_rightm_key_hit)
	interact_key_hit.disconnect(inter.on_inter_key_hit)

func _register_force_connects(inter: InteractComponent):
	#var f
	#if inter is Grabbable: f = _deregister_grab
	#else: return
	#inter.item_comp.force_done.connect(f)
	inter.force_done.connect(_deregister_grab)

func _deregister_force_connects(inter: InteractComponent):
	#var f
	#if inter is Grabbable: f = _deregister_grab
	#else: return
	#inter.item_comp.force_done.disconnect(f)
	inter.force_done.disconnect(_deregister_grab)

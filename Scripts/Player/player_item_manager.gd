extends PlayerComponent

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
		if is_grab(): _deregister_grab()
	if event.is_action_pressed("interact1"):
		interact_key_hit.emit()
	if event.is_action_pressed("left_mouse"):
		leftm_key_hit.emit()
	if event.is_action_pressed("right_mouse"):
		rightm_key_hit.emit()

func _on_int_scan_interacted_external_item(inter: Interactable) -> void:
	if inter is Rideable:
		if not is_ride():
			cur_ride = inter
			_register_ride()
	elif inter is Grabbable:
		if not is_grab():
			cur_grab = inter
			_register_grab()
	else:
		push_error("item is not interactable, but not found to be specific: ", inter.name)
		allow_interaction.emit()

func _register_ride(): 
	if not is_ride(): return

func _deregister_ride():
	if not is_ride(): return

func _register_grab():
	if not is_grab(): return
	cur_grab.register(player_ref.camera, player_ref.hip_hold_marker)
	_register_key_connects(cur_grab)
	_register_force_connects(cur_grab)
	cur_grab.reparent(player_ref.camera)
	grabbed_item.emit()

func _deregister_grab():
	if not is_grab(): return
	_deregister_key_connects(cur_grab)
	_deregister_force_connects(cur_grab)
	cur_grab.deregister()
	cur_grab.reparent(WorldAPI.get_world())
	cur_grab = null
	allow_interaction.emit()
	dropped_item.emit()

func is_grab() -> bool:
	return (cur_grab != null)
	
func is_ride() -> bool:
	return (cur_ride != null)

func _register_key_connects(inter: Interactable):
	leftm_key_hit.connect(inter.item_comp.on_leftm_key_hit)
	rightm_key_hit.connect(inter.item_comp.on_rightm_key_hit)
	interact_key_hit.connect(inter.item_comp.on_inter_key_hit)

func _deregister_key_connects(inter: Interactable):
	leftm_key_hit.disconnect(inter.item_comp.on_leftm_key_hit)
	rightm_key_hit.disconnect(inter.item_comp.on_rightm_key_hit)
	interact_key_hit.disconnect(inter.item_comp.on_inter_key_hit)
	
func _register_force_connects(inter: Interactable):
	var f
	if inter is Grabbable: f = _deregister_grab
	else: return
	inter.item_comp.force_done.connect(f)

func _deregister_force_connects(inter: Interactable):
	var f
	if inter is Grabbable: f = _deregister_grab
	else: return
	inter.item_comp.force_done.disconnect(f)

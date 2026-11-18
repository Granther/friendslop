extends Control

@onready var health_bar: ProgressBar = $MarginContainer/HealthContainer/VBoxContainer/HealthBar
@onready var slot_container: VBoxContainer = $MarginContainer/InvContainer/InvSlots

var INV_SLOTS_LABELS: Dictionary = { 0: null }
var inv_slots: Dictionary = {}
var cur_inv_slot_n: int = 0
var n_slots_filled: int = 0

signal inv_slot_changed(slot: int)

func _ready() -> void:
	_set_health_lvl(100)
	_set_inv_slot_labels()

func inv_space_avail() -> bool:
	return (n_slots_filled < ( len(INV_SLOTS_LABELS.keys()) - 1))

func add_to_inv(item_id: int) -> void:
	print("aded to inv etc")
	MultiplayerApi.client2server(
		InvPickupPacket.create_pickup(MultiplayerApi.peer_id, ResPreloader.ITEM.GUN)
	)
	
func remove_item() -> void:
	pass

func _set_inv_slot_labels() -> void:
	var slots: Array[Node] = slot_container.get_children() 
	for i in range(len(slots) + 1):
		INV_SLOTS_LABELS[i] = slots[i-1]
		inv_slots[i] = null

func _set_health_lvl(health: int):
	health_bar.value = health

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("inv1"):
		_handle_inv_switch(1)
	elif event.is_action_pressed("inv2"): 
		_handle_inv_switch(2)
	elif event.is_action_pressed("inv3"): 
		_handle_inv_switch(3)
	
func _handle_inv_switch(slot: int) -> void:
	if cur_inv_slot_n == slot: return
	cur_inv_slot_n = slot
	#INV_SLOTS[slot].get_theme_stylebox("panel").bg_color = Color.BLUE
	inv_slot_changed.emit(slot)

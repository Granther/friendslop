extends Node3D

# Player Item Manager
# Keeps track of player's items that are currently in their hand

@onready var right_arm = $"../Head/Stoneman/Right Arm Target"
@onready var left_arm = $"../Head/Stoneman/Left Arm Target"

signal grabbed_item(item: Node3D)
signal dropped_item
signal done_interacting

signal drop_key_hit
signal leftm_key_hit
signal rightm_key_hit
signal interact_key_hit

var cur_item: Node3D = null
var holding_item: bool = false
var phys_func = func(): pass

@export var root_player: CharacterBody3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("drop"):
		drop_key_hit.emit()
	if event.is_action_pressed("interact1"):
		interact_key_hit.emit()

func _on_int_scan_interacted_external_item(item: Node3D) -> void:
	item.item_comp.register(self)
	# This is all happening in our hand
	if not has_item():
		if item.item_comp.is_grabbable():
			drop_key_hit.connect(item.item_comp.on_drop_key_hit)
			leftm_key_hit.connect(item.item_comp.on_leftm_key_hit)
			rightm_key_hit.connect(item.item_comp.on_rightm_key_hit)
			interact_key_hit.connect(item.item_comp.on_inter_key_hit)
			grab_item(item)
		elif item.item_comp.is_npc():
			print("npc interact etc")
		else:
			push_error("item is not grabbable: ", item.name)

func grab_item(item: Node):
	cur_item = item
	# Check if cur_item has interaction_component
	cur_item.reparent(root_player.springarm)
	# cur_item.item_comp.prep_grab.call()
	grabbed_item.emit(cur_item)
	phys_func = set_arm_transforms

func drop_item():
	cur_item.reparent(get_tree().root)
	# cur_item.item_comp.prep_drop.call()
	cur_item = null
	dropped_item.emit()
	done_interacting.emit()
	phys_func = func(): pass

func has_item() -> bool:
	return (cur_item != null)

func set_arm_transforms():
	right_arm.global_position = cur_item.global_position
	left_arm.global_position = cur_item.global_position

func _physics_process(delta: float) -> void:
	phys_func.call()

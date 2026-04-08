extends Node3D

# Player Item Manager
# Keeps track of player's items that are currently in their hand

@onready var right_arm = $"../Head/Stoneman/Right Arm Target"
@onready var left_arm = $"../Head/Stoneman/Left Arm Target"

signal grabbed_item(item: Node3D)
signal dropped_item

var cur_item: Node3D = null
var holding_item: bool = false

@export var root_player: CharacterBody3D

func _on_int_scan_interacted_external_item(item: Node3D) -> void:
	if not has_item():
		if item.item_comp.is_grabbable():
			grab_item(item)
		else:
			push_error("item is not grabbable: ", item.name)

func _on_int_scan_drop_item() -> void:
	drop_item()

func grab_item(item: Node):
	cur_item = item
	# Check if cur_item has interaction_component
	cur_item.reparent(root_player.springarm)
	cur_item.item_comp.prep_grab.call()
	emit_signal("grabbed_item", cur_item)
	holding_item = true

func drop_item():
	cur_item.reparent(get_tree().root)
	cur_item.item_comp.prep_drop.call()
	cur_item = null
	emit_signal("dropped_item")
	holding_item = false

func has_item() -> bool:
	return (cur_item != null)

func _physics_process(delta: float) -> void:
	if holding_item:
		right_arm.global_position = cur_item.global_position
		left_arm.global_position = cur_item.global_position

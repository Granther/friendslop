extends Node3D

# Player Item Manager
# Keeps track of player's items that are currently in their hand

signal grabbed_item(item: Node3D)
signal dropped_item

var cur_item: Node3D = null

@export var root_player: CharacterBody3D

func _on_int_scan_interacted_external_item(item: Node3D) -> void:
	if not has_item():
		set_item(item)

func _on_int_scan_drop_item() -> void:
	drop_item()

func set_item(item: Node):
	cur_item = item
	cur_item.get_root_obj().reparent(root_player.springarm)
	emit_signal("grabbed_item", cur_item)

func drop_item():
	cur_item.get_root_obj().reparent(get_tree().root)
	cur_item = null
	emit_signal("dropped_item")

func has_item() -> bool:
	return (cur_item != null)

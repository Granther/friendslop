extends Node3D

var cur_item: Node = null

func set_item(item: Node):
	print("set item")
	cur_item = item

func drop_item():
	cur_item = null

func has_item() -> bool:
	return (cur_item != null)

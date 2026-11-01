class_name HoverInteractComponent extends InteractComponent

func interact():
	_interact.rpc()

@rpc("call_local", "any_peer")
func _interact():
	print("interaction")

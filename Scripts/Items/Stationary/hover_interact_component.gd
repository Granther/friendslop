extends BaseComponent

@onready var interaction_area: Area3D = $InteractionArea

func interact():
	_interact.rpc()

@rpc("call_local", "any_peer")
func _interact():
	print("interaction")

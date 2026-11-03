class_name HoverInteractComponent extends InteractComponent

# override the _interact function to allow that to happen on inter

var interact_func = func(n: Node): pass

func _ready() -> void:
	Err.push_err_if(interact_func == func(): pass, "hover_inter_comp must have a valid interact_fn passed")

func interact(interactor: Node):
	_interact_synced.rpc(interactor.get_path())

@rpc("call_local", "any_peer")
func _interact_synced(player_path: NodePath):
	interact_func.call(get_node(player_path))

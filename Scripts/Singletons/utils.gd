extends Node

@rpc("call_local", "authority", "reliable")
func destroy_net(body_p: NodePath):
	if not multiplayer.is_server(): return
	var body = get_node(body_p)
	body.queue_free()

@rpc("call_local", "any_peer", "reliable")
func add_child_multi(thing_p: NodePath): 
	if thing_p != null:
		WorldAPI.get_world().add_child(get_node(thing_p))

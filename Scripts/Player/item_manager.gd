extends Node

var cur_item: Node3D
var is_holding_item: bool = false
var player: CharacterBody3D

func register_player(p: CharacterBody3D):
	player = p

func pickup_item(item: Node3D) -> Error:
	if is_holding_item: return Error.ERR_SCRIPT_FAILED
	is_holding_item = true
	cur_item = item
	player.pickup(cur_item)
	return Error.OK

# If not holding something, silently does nothing
func drop_item():
	cur_item = null
	is_holding_item = false

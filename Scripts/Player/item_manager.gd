extends Node

var cur_item: Node3D
var is_holding_item: bool = false

func pickup_item(item: Node3D) -> Error:
	if is_holding_item: return Error.ERR_SCRIPT_FAILED
	is_holding_item = true
	cur_item = item
	return Error.OK

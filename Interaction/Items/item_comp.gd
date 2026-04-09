extends Node3D

@export var is_grab: bool

var item_manager

# Key signals
var on_drop_key_hit: Callable = func(): pass
var on_leftm_key_hit: Callable = func(): pass
var on_rightm_key_hit: Callable = func(): pass
var on_inter_key_hit: Callable = func(): pass

var phys_func: Callable = func(): pass

func register(_item_manager):
	item_manager = _item_manager

func is_grabbable():
	return is_grab

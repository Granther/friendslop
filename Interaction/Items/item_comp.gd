extends Node3D

@export var is_grab: bool

var player_ref

# Key signals
var on_drop_key_hit: Callable = func(): pass
var on_leftm_key_hit: Callable = func(): pass
var on_rightm_key_hit: Callable = func(): pass
var on_inter_key_hit: Callable = func(): pass
var on_register: Callable = func(): pass
var on_deregister: Callable = func(): pass

var phys_func: Callable = func(): pass

func register(_player_ref):
	player_ref = _player_ref
	on_register.call()
	
func deregister():
	on_deregister.call()
	player_ref = null

func is_grabbable():
	return is_grab

func _physics_process(delta: float) -> void:
	phys_func.call()

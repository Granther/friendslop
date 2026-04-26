extends Node3D

@export var is_grab: bool
@export var left_hand_anchor: Node3D
@export var right_hand_anchor: Node3D

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
	# player_ref = null Should we be able to hand onto this player_ref

func is_grabbable():
	return is_grab

func _process(delta: float) -> void:
	phys_func.call()

#func _physics_process(delta: float) -> void:
	#phys_func.call()

extends Node

signal done_inter

var player_ref

# Key signals
var on_drop_key_hit: Callable = func(): pass
var on_leftm_key_hit: Callable = func(): pass
var on_rightm_key_hit: Callable = func(): pass
var on_inter_key_hit: Callable = func(): pass
# called when the interaction system first talks to the item
var on_register: Callable = func(): pass
# called by the interaction system after its done with the item
var on_deregister: Callable = func(): pass

var phys_func: Callable = func(): pass

func register(_player_ref):
	player_ref = _player_ref
	on_register.call()
	
func deregister():
	on_deregister.call()
	# player_ref = null Should we be able to hand onto this player_ref

func _process(delta: float) -> void:
	phys_func.call()

#func _physics_process(delta: float) -> void:
	#phys_func.call()

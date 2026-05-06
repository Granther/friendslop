extends InteractableComponent

# var player_ref: CharacterBody3D = null

signal force_done

# Key signals
var on_drop_key_hit: Callable = func(): pass
var on_leftm_key_hit: Callable = func(): pass
var on_rightm_key_hit: Callable = func(): pass
var on_inter_key_hit: Callable = func(): pass
# called when the interaction system first talks to the item
#var on_register: Callable = func(_player_ref: CharacterBody3D, camera: Camera3D, anchor: Marker3D): pass
## called by the interaction system after its done with the item
#var on_deregister: Callable = func(): pass

var NULL_FUNC = func(): pass
var phys_func = func(): pass
var proc_func = func(): pass

#func register(_player_ref: CharacterBody3D, camera: Camera3D, anchor: Marker3D):
	#player_ref = _player_ref
	#on_register.call(camera, anchor)
	#
#func deregister():
	#on_deregister.call()
	#player_ref = null

func _physics_process(delta: float) -> void:
	phys_func.call()
	
func _process(delta: float) -> void:
	proc_func.call()

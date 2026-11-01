extends RigidBody3D

@export var icomp: InteractComponent
@export var multi_comp: PhysItemMultiComp

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	icomp.on_leftm_key_hit = Callable(self, "_on_leftm_key_hit")
	
func get_icomp() -> InteractComponent:
	return icomp

func get_multi_comp() -> PhysItemMultiComp:
	return multi_comp

func _on_inter():
	pass
	
func _on_leftm_key_hit():
	pass

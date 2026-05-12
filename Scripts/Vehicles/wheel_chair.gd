extends VehicleBody3D

@export var icomp: InteractComponent

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	
func get_icomp() -> InteractComponent:
	return icomp

func _on_inter():
	pass

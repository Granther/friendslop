extends CSGBox3D

@onready var interaction_area: InteractionArea = $InteractionArea
# Loads string path as type
var purple_mat = preload("res://Materials/purple.tres")
var blue_mat = preload("res://Materials/light_blue.tres")

func _ready() -> void:
	# interaction_area.interact = Callable(self, "_on_interact")
	pass

func _on_interact() -> void:
	if get_material() == purple_mat:
		set_mat.rpc(blue_mat)
	else:
		set_mat.rpc(purple_mat)

@rpc("any_peer", "call_local")
func set_mat(mat: Material):
	set_material(mat)

extends Area3D
class_name InteractionArea

@export var label: Label3D
@export var root_object: Node3D

signal entered_inter_zone 
signal exited_inter_zone
signal interacted_with

func set_label_visible(setting: bool):
	if setting:
		entered_inter_zone.emit()
	else: 
		exited_inter_zone.emit()

func interact(player):
	interacted_with.emit(player)

func get_root_obj() -> Node3D:
	return root_object

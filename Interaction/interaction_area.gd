extends Area3D
class_name InteractionArea

# Requires: 
# - Label 3D. At (0,0,0)
# - Collision shape for which the label shows up

@export var label: Label3D
@export var root_object: Node3D
@export var action_name: String = "interact"
@export var base_text: String = "[E] to "

signal entered_inter_zone 
signal exited_inter_zone
signal interacted_with

func _ready():
	label.text = base_text + action_name

func set_label_visible(setting: bool):
	pass
	#if setting:
		#label.show()
	#else:
		#label.hide()

func interact(player):
	interacted_with.emit(player)

func get_root_obj() -> Node3D:
	return root_object

func _process(delta):
	# Ensure label stays above ball at all times
	label.global_position = global_position
	label.global_position.y += 0.5

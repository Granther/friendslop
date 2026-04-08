extends RigidBody3D
class_name Ball

@onready var interaction_area = $InteractionArea
@onready var item_comp = $ItemComp

func _ready():
	#interaction_area.entered_inter_zone.connect(_on_in_range)
	#interaction_area.exited_inter_zone.connect(_on_out_range)
	#interaction_area.interacted_with.connect(_pickup_ball)
	#
	item_comp.prep_grab = Callable(self, "_prep_grab")
	item_comp.prep_drop = Callable(self, "_prep_drop")

func get_exploded(source: Vector3):
	apply_central_force((global_transform.origin - source).normalized() * 1)

#func _on_in_range():
	#label.show()
	#
#func _on_out_range():
	#label.hide()
#
#func _pickup_ball(player):
	#label.hide()

# func _drop_ball(player):
	
	
func _prep_grab():
	interaction_area.set_label_visible(false)
	
func _prep_drop():
	interaction_area.set_label_visible(true)

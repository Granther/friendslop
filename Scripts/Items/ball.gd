extends RigidBody3D
class_name Ball

const base_text = "[E] to "

@onready var label = $InteractionLabel
@onready var interaction_area = $InteractionArea
@export var action_name: String

func _ready():
	label.text = base_text + action_name
	interaction_area.entered_inter_zone.connect(_on_in_range)
	interaction_area.exited_inter_zone.connect(_on_out_range)
	interaction_area.interacted_with.connect(_pickup_ball)

func get_exploded(source: Vector3):
	apply_central_force((global_transform.origin - source).normalized() * 1)

func _on_in_range():
	label.show()
	
func _on_out_range():
	label.hide()

func _pickup_ball(player):
	label.hide()
	#var err = ItemManager.pickup_item(self)
	#if err != OK:
		#push_error(err)

func _drop_ball(player):
	#ItemManager.drop_item()
	pass
	
func _process(delta):
	# Ensure label stays above ball at all times
	label.global_position = global_position
	label.global_position.y += 0.5

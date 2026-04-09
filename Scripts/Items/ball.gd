extends RigidBody3D
class_name Ball

@onready var interaction_area = $InteractionArea
@onready var item_comp = $ItemComp

func _ready():
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")

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

func _on_inter():
	var throw_angle = clamp(item_comp.item_manager.root_player.velocity.length() * (item_comp.item_manager.root_player.camera.rotation.x * 3), -50, 50)
	apply_impulse((-item_comp.item_manager.root_player.head.global_basis.z * item_comp.item_manager.root_player.velocity.length()*2) + Vector3(0,throw_angle,0))
	item_comp.item_manager.drop_item()
	print("should throw")

func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.item_manager.drop_item()

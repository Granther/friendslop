extends RigidBody3D
class_name Ball

@onready var interaction_area = $InteractionArea
@onready var item_comp = $ItemComp

func _ready():
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

func get_exploded(source: Vector3):
	apply_central_force((global_transform.origin - source).normalized() * 1)

func _on_register():
	item_comp.phys_func = func():
		item_comp.player_ref.left_arm.global_position = global_position
		item_comp.player_ref.right_arm.global_position = global_position

func _on_deregister():
	item_comp.phys_func = func(): pass

func _on_inter():
	#var throw_angle = clamp(item_comp.player_ref.velocity.length() * (item_comp.player_ref.camera.rotation.x * 3), -50, 50)
	#apply_impulse((-item_comp.player_ref.head.global_basis.z * item_comp.player_ref.velocity.length()*2) + Vector3(0,throw_angle,0))
	#item_comp.player_ref.item_manager.drop_item()
	print("would throw")

func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.player_ref.item_manager.drop_item()

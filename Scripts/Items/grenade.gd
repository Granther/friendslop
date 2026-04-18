extends Grabbable
class_name Grenade

@export var fuse_time: float

@onready var fuse_timer = $FuseTimer

var armed: bool = false
var aoe_effect_scene = preload("res://Scenes/Gameplay/AOE/AOEEffect.tscn")

func _ready():
	_runtime_checks()
	fuse_timer.set_wait_time(fuse_time)
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

#func _on_register():
	#
	#interaction_area.set_label_visible(false)
	#_set_freeze(true)
	#item_comp.phys_func = func():
		#global_rotation = Vector3.ZERO
		#item_comp.player_ref.left_arm.global_position = global_position
		#item_comp.player_ref.right_arm.global_position = global_position
#
#func _on_deregister():
	#_set_freeze(false)
	#interaction_area.set_collision_layer_value(5, true)
	#item_comp.phys_func = func(): pass

func _on_inter():
	if armed:
		print("throw")
		item_comp.on_drop_key_hit.call()
	else: # We are not armed, but its in our hand
		print("starting")
		fuse_timer.start()
		armed = true

func _on_fuse_timer_timeout() -> void:
	item_comp.player_ref.item_manager.remove_item()
	var aoe_effect = aoe_effect_scene.instantiate()
	aoe_effect.global_position = global_position
	WorldAPI.get_world().add_child(aoe_effect)
	aoe_effect.area_blast(1)
	queue_free()

func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.player_ref.item_manager.drop_item()

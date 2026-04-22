extends Grabbable
class_name Grenade

@export var fuse_time: float
@export var blast_force: float

@onready var fuse_timer = $FuseTimer
@onready var kill_area = $KillArea

var armed: bool = false
var aoe_effect_scene = preload("res://Scenes/Gameplay/AOE/AOEEffect.tscn")

func _ready():
	_runtime_checks()
	fuse_timer.set_wait_time(fuse_time)
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

func _on_inter():
	if armed:
		item_comp.on_drop_key_hit.call()
	else: # We are not armed, but its in our hand
		fuse_timer.start()
		armed = true

func _on_fuse_timer_timeout() -> void:
	if item_comp.player_ref != null and item_comp.player_ref.item_manager.has_item():
		item_comp.player_ref.item_manager.remove_item()
	var aoe_effect = aoe_effect_scene.instantiate()
	aoe_effect.effect_area = kill_area
	aoe_effect.global_position = global_position
	WorldAPI.get_world().add_child(aoe_effect)
	aoe_effect.area_blast(blast_force)
	queue_free()

func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.player_ref.item_manager.drop_item()

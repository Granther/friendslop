extends RigidBody3D

# This grenade is just a rigidbody but it has components that make it Grabbable

@export var fuse_time: float
@export var blast_force: float
@export var icomp: InteractComponent

@onready var fuse_timer = $FuseTimer
@onready var kill_area = $KillArea

var armed: bool = false
var aoe_effect_scene = preload("res://Scenes/Gameplay/AOE/AOEEffect.tscn")

func _ready():
	fuse_timer.set_wait_time(fuse_time)
	icomp.on_inter_key_hit = Callable(self, "_on_inter")

func get_icomp() -> InteractComponent:
	return icomp

func _on_inter():
	if armed:
		icomp.on_drop_key_hit.call()
	else: # We are not armed, but its in our hand
		fuse_timer.start()
		armed = true

func _on_fuse_timer_timeout() -> void:
	icomp.force_done.emit()
	var aoe_effect = aoe_effect_scene.instantiate()
	aoe_effect.effect_area = kill_area
	aoe_effect.global_position = global_position
	WorldAPI.get_world().add_child(aoe_effect)
	aoe_effect.area_blast(blast_force)
	queue_free()

extends Node3D

# I know, I know. I know that each object should only have one job, but this one will maybe play anims..

# Area for which all items in it will get the affect applied

@onready var effect_coll = $Area3D/CollisionShape3D
@onready var anims_sprite = $AnimatedSprite3D 
var effect_area: Area3D = null

func _ready() -> void:
	Err.push_err_if(not effect_area.get_collision_mask_value(6), "AOEEffect must be listening on AOE layer")
	Err.push_err_if(effect_coll == null, "AOEEffect must have effect_area CollisionShape3D")
	
func _play_scaled_anim(name: String, scale: float):
	# anims_sprite.scale = Vector3(scale, scale, scale)
	anims_sprite.show()
	anims_sprite.play(name)
	await anims_sprite.animation_finished
	anims_sprite.hide()

func area_blast(force_mag: float = 1):
	var bodies = effect_area.get_overlapping_bodies()
	for bod in bodies:
		if bod is RigidBody3D:
			bod.apply_central_impulse((bod.global_transform.origin - global_position).normalized()*force_mag)
	await _play_scaled_anim("area_blast", force_mag)
	queue_free()

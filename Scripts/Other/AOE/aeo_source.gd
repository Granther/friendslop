extends Area3D

# Area for which all items in it will get the affect applied
@export var effect_area: CollisionShape3D

func _ready() -> void:
	assert(get_collision_mask_value(6), "AOESource must be listening on 'AOE' layer")

func area_blast(source: Vector3, force_mag: float = 1):
	var areas = get_overlapping_areas()
	for area in areas:
		area.get_blasted(source, force_mag)

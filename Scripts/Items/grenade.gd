extends RigidBody3D

@onready var blast_radius = $BlastRadius
@onready var fuse_timer = $FuseTimer

func _on_fuse_timer_timeout() -> void:
	hide()
	# Uses Area3D's child CollisionShape to search for all bodies
	# Also, we are reading from the "Explodable" phys layer, so we only see things that can be
	# ie, we dont need to check that is is explodable
	var bodies = blast_radius.get_overlapping_bodies()
	print(len(bodies))
	for bod in bodies:
		bod.get_exploded(global_transform.origin)

func _ready():
	fuse_timer.start()

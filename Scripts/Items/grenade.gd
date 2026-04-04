extends RigidBody3D

@onready var blast_radius = $BlastRadius
@onready var fuse_timer = $FuseTimer
@onready var interaction_area: InteractionArea = $InteractionArea

func _on_fuse_timer_timeout() -> void:
	hide()
	# Uses Area3D's child CollisionShape to search for all bodies
	# Also, we are reading from the "Explodable" phys layer, so we only see things that can be
	# ie, we dont need to check that is is explodable
	var bodies = blast_radius.get_overlapping_bodies()
	for bod in bodies:
		bod.get_exploded(global_transform.origin)

func _ready():
	interaction_area.interact = Callable(self, "_on_interact")
	fuse_timer.start()

func _on_interact() -> void:
	if ItemManager.has_item():
		ItemManager.drop_item()
	else:
		ItemManager.set_item(self)

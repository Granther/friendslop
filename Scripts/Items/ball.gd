extends RigidBody3D
class_name Ball

func get_exploded(source: Vector3):
	apply_central_force((global_transform.origin - source).normalized() * 1)

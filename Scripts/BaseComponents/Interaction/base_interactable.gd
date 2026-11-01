extends RigidBody3D
class_name Interactable

# Can we use this to guaruntee that an item comp is in place?

@export var interaction_area: InteractionArea
@export var item_comp: InteractableComponent

func _runtime_checks():
	# For picking up
	Err.push_err_if(not interaction_area.get_collision_layer_value(5), "grabbable object's InteractionArea must be on the Interactables layer")
	# For colliding with player and world
	Err.push_err_if(not get_collision_layer_value(5), "grabbable object must be on the Interactables layer")

func register(camera: Camera3D, anchor: Marker3D): pass

func degregister(): pass

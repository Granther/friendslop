class_name InteractComponent
extends Node

@export var type: Node
@export var interact_data: InteractResource
@export var root_obj: Node

@onready var interaction_area: Area3D = $InteractionArea
@onready var inter_col_shape: CollisionShape3D = $InteractionArea/CollisionShape3D

# Emitted to the player when we want to be dropped or generally done with
signal force_done

var on_drop_key_hit: Callable = func(): pass
var on_leftm_key_hit: Callable = func(): pass
var on_rightm_key_hit: Callable = func(): pass
var on_inter_key_hit: Callable = func(): pass

var NULL_FUNC = func(): pass
var phys_func = func(): pass
var proc_func = func(): pass

func _ready():
	# What if we never even needed a method because the interaction area just directly got the Interaction...
	# ... Component. So, we don't need to even depend on the item having these methods
	Err.push_err_if(not root_obj.has_method("get_icomp"), "parent of InteractComponent MUST have method get_icomp() -> InteractComponent")
	# For picking up
	Err.push_err_if(not interaction_area.get_collision_layer_value(5), "grabbable object's InteractionArea must be on the Interactables layer")
	# For colliding with player and world
	Err.push_err_if(not root_obj.get_collision_layer_value(5), "grabbable object must be on the Interactables layer")
	inter_col_shape.shape.radius = (interact_data.interact_distance * 2)

func register(camera: Camera3D, anchor: Marker3D):
	type.register(camera, anchor)

# We are assuming that ALL base grabbables need to run this and don't need it overriden
# Humans are terrible at predicting the future
func deregister():
	type.deregister()

func _process(delta: float) -> void:
	proc_func.call()
	
func _physics_process(delta: float) -> void:
	phys_func.call()

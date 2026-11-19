class_name InvEquip extends Node3D

@export var equip_comp: PickupComponent

# get the mesh shown when lying on ground at onready, should already be hidden
@onready var on_ground_container: Node3D = get_node("OnGround")
@onready var default_container: Node3D = get_node("Default")
@onready var ground_raycast: RayCast3D = $GroundRayCast

var type: ResPreloader.ITEM = ResPreloader.ITEM.NONE
var id: int # things like this need an ID to by synced on net

func _ready() -> void:
	equip_comp.registered.connect(_on_inter)
	equip_comp.deregistered.connect(_on_drop)

func init():
	await WorldAPI.current_world.ready
	ground_raycast.force_raycast_update()
	drop_item()

# called to find the ground and then set the pos of the item right there 
func drop_item():
	if ground_raycast.is_colliding():
		global_position = ground_raycast.get_collision_point()
		default_container.visible = false
		on_ground_container.visible = true
		# now, this exposes it to be accessed for picking up

func picked_up():
	default_container.visible = true
	on_ground_container.visible = false

func _on_inter(): pass
func _on_drop(): pass

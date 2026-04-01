extends Area3D
class_name InteractionArea

@export var action_name: String = "interact"
# Label, located uniquly in space for particular item
@export var label: Label3D

func _ready():
	label.hide()

var interact: Callable = func():
	pass

func _on_body_entered(body: Node3D) -> void:
	# Pass in InteractionArea
	InteractionManager.register_area(self, label)


func _on_body_exited(body: Node3D) -> void:
	InteractionManager.unregister_area(self)

# Note about collision areas and masks
# ... formum: "
	#Collision layer is what the body lies in. It’s its little world, it just exists in that layer.
	#Collision mask is what the object looks towards when searching for collisions. It’s what it’s interested in.
#Some examples:
	#Terrain has collision layer of 1 and player has collision mask of 1. The player is looking for terrain to collide with and when it sees some, it stops."

# So, the terminal does not have a layer. ie, it doesnt exist to collide with in any world
# The mask is what the terminal is listening on for the body_{exit, entered} func. 

# It also seems like items inhereit the collision layers from their parents

extends RigidBody3D

var target: Node = null

func _ready():
	get_tree().node_added.connect(node_added)

func _process(delta: float) -> void:
	if target != null:
		look_at(target.position)

func node_added(node: Node):
	if node is CharacterBody3D:
		target = node

class_name BaseWorld extends Node3D

# we always need to spawn into a world, so, it should always be able to offer us a spawnpoint

@export var spawnpoint_comp: SpawnpointComponent

func _ready() -> void:
	Err.push_err_if(not self.has_node("MultiplayerSpawner"), "every world must have a multiplayer spawner")
	Err.push_err_if(spawnpoint_comp == null, "every world must have at least one spawnpoint")

# we cab use this to spawn other players in the world from another
func get_spawnpoint_comp() -> SpawnpointComponent:
	return spawnpoint_comp

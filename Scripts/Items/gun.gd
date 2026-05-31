extends RigidBody3D

@export var icomp: InteractComponent
@export var multi_comp: PhysItemMultiComp

@onready var bullet_scene = preload("res://Scenes/Items/bullet.tscn")
@onready var bullet_spawn_loc: Marker3D = $BulletSpawnLocation
@onready var spawner = $MultiplayerSpawner

func _ready():
	icomp.on_inter_key_hit = Callable(self, "_on_inter")
	icomp.on_leftm_key_hit = Callable(self, "_on_leftm_key_hit")
	
func get_icomp() -> InteractComponent:
	return icomp

func get_multi_comp() -> PhysItemMultiComp:
	return multi_comp

func _on_inter():
	pass
	
func _on_leftm_key_hit():
	var bullet: Bullet = bullet_scene.instantiate()
	WorldAPI.get_world().add_child(bullet)
	bullet.initialize(bullet_spawn_loc.global_position, -global_transform.basis.z, 100)

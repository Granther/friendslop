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
	fire_bullet.rpc(bullet_spawn_loc.global_position, multiplayer.get_unique_id())

@rpc("call_local", "any_peer", "unreliable")
func fire_bullet(spawn_pos: Vector3, peer_id: int):
	var bullet: Bullet = bullet_scene.instantiate()
	# Must change some data or else we can't replicate (it would delete all of them)
	# bullet.name = str(randi_range(1, 1000)) # This is kinda dumb tho lol
	WorldAPI.get_world().add_child(bullet)
	bullet.global_rotation = global_rotation # Set bullet to same rotation as gun
	bullet.initialize(spawn_pos, -global_transform.basis.z, 50, (multiplayer.get_unique_id() == peer_id))

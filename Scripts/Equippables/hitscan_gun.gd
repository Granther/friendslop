extends RigidBody3D

@export var equip_comp: EquipComponent
@export var damage: int

@onready var handle_marker: Marker3D = $HandleMarker
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	equip_comp.on_inter_key_hit = Callable(self, "_on_inter")
	equip_comp.on_leftm_key_hit = Callable(self, "_on_leftm_key_hit")
	 
func get_icomp() -> InteractComponent:
	return equip_comp

func _on_inter():
	pass
	
func _on_leftm_key_hit():
	animation_player.play("fire")
	if equip_comp.player_ref.ranged_raycast.is_colliding():
		var obj_hit = equip_comp.player_ref.ranged_raycast.get_collider()
		if obj_hit.has_node("HealthComponent"):
			obj_hit.get_node("HealthComponent").damage.rpc(damage)

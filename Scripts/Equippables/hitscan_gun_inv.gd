extends InvEquip

@export var damage: int

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var in_hand: bool = false

func _ready() -> void:
	super._ready()
	equip_comp.on_leftm_key_hit = Callable(self, "_on_leftm_key_hit")
	type = ResPreloader.ITEM.GUN

func get_icomp() -> InteractComponent:
	return equip_comp

func _on_inter():
	picked_up()
	in_hand = true
	
func _on_drop():
	in_hand = false

func _process(delta: float) -> void:
	if not in_hand:
		drop_item()
	
func _on_leftm_key_hit():
	animation_player.play("fire")
	if equip_comp.player_ref.ranged_raycast.is_colliding():
		var obj_hit = equip_comp.player_ref.ranged_raycast.get_collider()
		if obj_hit.has_node("HealthComponent"):
			obj_hit.get_node("HealthComponent").damage.rpc(damage)

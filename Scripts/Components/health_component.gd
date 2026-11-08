class_name HealthComponent extends BaseComponent

signal damaged(health: int)
signal healed(health: int)
signal died
signal revived

@export var health := 100

#func initialize(_health: int) -> void:
	#health = _health

@rpc("call_local", "any_peer", "reliable")
func damage(n: int):
	health -= n
	damaged.emit(health)
	if health <= 0:
		health = 0
		died.emit()

@rpc("call_local", "any_peer", "reliable")
func heal(n: int):
	health += n
	healed.emit(health)

func get_health() -> int:
	return health

func _process(delta: float) -> void:
	pass

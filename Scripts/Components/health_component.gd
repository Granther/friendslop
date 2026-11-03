class_name HealthComponent extends BaseComponent

signal damaged
signal healed
signal died
signal revived

@export var health := 100

#func initialize(_health: int) -> void:
	#health = _health

@rpc("call_local", "any_peer", "reliable")
func damage(n: int):
	health -= n
	damaged.emit()
	if health <= 0:
		health = 0
		died.emit()

@rpc("call_local", "any_peer", "reliable")
func heal(n: int):
	health += n
	healed.emit()

func get_health() -> int:
	return health

func _process(delta: float) -> void:
	pass

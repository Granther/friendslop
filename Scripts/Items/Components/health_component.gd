class_name HealthComponent extends BaseComponent

signal damaged
signal healed

var health: float = 100

func initialize(_health: int) -> void:
	health = _health

func damage(n: int):
	health -= n
	damaged.emit()

func heal(n: int):
	health += n
	healed.emit()

func get_health() -> int:
	return health

func _process(delta: float) -> void:
	if health <= 0:
		root_obj.queue_free()

extends PlayerComponent

# Listens
# ItemManager:signal -> entered_ride
# ItemManager:signal -> exited_ride

var INPUT_DST: INPUT_OPT = INPUT_OPT.PLAYER
enum INPUT_OPT { PLAYER, NONE, VEHICLE }

# In case we havent assigned yet
var player_phys_func: Callable = func(delta: float): pass
var vehicle_phys_func: Callable = func(delta: float): pass

func _ready():
	phys_func = __phys

func set_player_phys(f): player_phys_func = f

func set_vehicle_phys(f): vehicle_phys_func = f

func __phys(delta: float):
	match(INPUT_DST):
		INPUT_OPT.PLAYER:
			player_phys_func.call(delta)
		INPUT_OPT.VEHICLE:
			vehicle_phys_func.call(delta)
		INPUT_OPT.NONE:
			pass
	
func _on_player_item_manager_entered_ride(phys_func: Callable) -> void:
	INPUT_DST = INPUT_OPT.VEHICLE
	set_vehicle_phys(phys_func)

func _on_player_item_manager_exited_ride() -> void:
	INPUT_DST = INPUT_OPT.PLAYER
	set_vehicle_phys(func(): pass)

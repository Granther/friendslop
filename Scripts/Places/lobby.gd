extends BaseWorld

func _ready() -> void:
	MultiplayerConnectionHandler.connected_new_player.connect(_setup_player)
	
func _setup_player(peer_id: int) -> void:
	spawnpoint_comp.spawn_new_player(peer_id)

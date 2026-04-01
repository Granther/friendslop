extends Node

const IP_A: String = "localhost"
const PORT: int = 42069

const IS_SERVER: int = 80
const IS_CLIENT: int = 90

var peer: ENetMultiplayerPeer

func start_server() -> int:
	peer = ENetMultiplayerPeer.new()
	var err = peer.create_server(PORT)
	if err != OK:
		return start_client()
	multiplayer.multiplayer_peer = peer
	print("Started local server")
	return IS_SERVER
	
func start_client() -> int:
	peer = ENetMultiplayerPeer.new()
	peer.create_client(IP_A, PORT)
	multiplayer.multiplayer_peer = peer
	print("Started local client")
	return IS_CLIENT

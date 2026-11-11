extends Node

var peer: NodeTunnelPeer
var relay_addr: String = "linode.doesnickwork.com:5000"
var relay_id: String = "glorp"

func start_server() -> String:
	await conn_to_relay()
	return await host_room()

func start_client(room_id) -> void:
	await conn_to_relay()
	await join_room(room_id)
	# Check error, kinda weird but aight
	return peer.error.connect(
		func(error_msg):
			push_error("NodeTunnel Error: ", error_msg)
	)

func conn_to_relay() -> void:
	peer = NodeTunnelPeer.new()
	peer.connect_to_relay(relay_addr, relay_id)
	multiplayer.multiplayer_peer = peer
	
	print("Authenticating")
	await peer.authenticated
	print("Authenticated!")

func host_room() -> String:
	peer.host_room(true, "room1")
	print("Hosting room...")
	await peer.room_connected
	var room_id: String = peer.room_id
	print("Connected to room: ", room_id)
	return room_id

func join_room(room_id) -> void:
	peer.join_room(room_id)
	print("Joining room...")
	await peer.room_connected
	print("Connected to room: ", peer.room_id)
	multiplayer.peer_connected.emit(multiplayer.get_unique_id())

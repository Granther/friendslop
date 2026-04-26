extends PanelContainer

# Instantiate, we are "starting" the world before we load it
var World = preload("res://Scenes/Places/world.tscn").instantiate()
const Player = preload("res://Scenes/Player/player.tscn")
# Whats a better way to do this? Not very scalable! What if the root lies 3 up, not 2
# @onready var parent_node = 
@onready var ui_parent = get_tree().root
@onready var room_id_box = $MarginContainer/VBoxContainer/RoomID
@onready var room_id_label = $"../RoomIDLabel"

var player: CharacterBody3D = null

func _ready():
	WorldAPI.set_world(World)
	room_id_label.hide()

func _on_local_btn_pressed() -> void:
	hide()
	ui_parent.add_child(WorldAPI.get_world())
	var status = LocalMultiplayerHandler.start_server()
	if status == LocalMultiplayerHandler.IS_SERVER:
		_setup_peer_host_signals()
		add_player(multiplayer.get_unique_id())

func _on_join_btn_pressed() -> void:
	# Ensure player actually entered code, else just try again, should show some kind of error
	if room_id_box.text == null or room_id_box.text == "":
		return
	hide()
	await RemoteMultiplayerHandler.start_client(room_id_box.text)

func _on_host_btn_pressed() -> void:
	hide()
	var room_id: String = await RemoteMultiplayerHandler.start_server()
	set_room_id_ui(room_id)
	_setup_peer_host_signals()
	add_player(multiplayer.get_unique_id())

func add_player(peer_id):
	print("Adding peer: ", peer_id)
	if peer_id == 1:
		var player = Player.instantiate()
		player.name = str(peer_id)
	WorldAPI.get_world().add_child(player)
	
func remove_player(peer_id):
	WorldAPI.get_world().remove_child(WorldAPI.get_world().get_node(str(peer_id)))
	
func set_room_id_ui(room_id: String):
	room_id_label.text = room_id
	room_id_label.show()

func peer_connected(peer_id: int):
	print("hit")
	add_player(peer_id)

# I think we want to call this on the server somehow, but, also on all clients to remove the specific player
func peer_disconnected(peer_id: int):
	print("Peer disconnected called for peer: ", peer_id)
	remove_player(peer_id)

#func client_peer_disconnected(peer_id: int):
	#print("Peer disconnected called for peer: ", peer_id)
	#if peer_id == 0:
		#print("Server peer disconnected")
		#get_tree().quit()
#
#func client_peer_connected(peer_id: int):
	#add_player(peer_id)

func _setup_peer_host_signals():
	print("setting up host signlas")
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	
#func _setup_peer_client_signals():
	#multiplayer.peer_connected.connect(client_peer_connected)
	#multiplayer.peer_disconnected.connect(client_peer_disconnected)

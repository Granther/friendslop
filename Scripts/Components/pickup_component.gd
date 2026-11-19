class_name PickupComponent extends EquipComponent

# Applies to InvEquip derived items, this is added as a component to a rigidbody or area3d on the object, allows for player to interact 

signal registered
signal deregistered

func register(player: BasePlayer):
	print("got red in pickup compt")
	# i think this is where we should set the arm view
	root_obj.reparent(player)
	root_obj.global_position = player.right_hand_obj_marker.global_position
	registered.emit()
	
	MultiplayerApi.client2server(
		InvPickupPacket.create_pickup(MultiplayerApi.peer_id, ResPreloader.ITEM.GUN)
	)
	MultiplayerApi.client2server(
		ItemPacket.create(root_obj.id, ItemPacket.ITEM_OPT.DELETE, ResPreloader.ITEM.GUN
	))

func deregister():
	# then rm it
	root_obj.reparent(WorldAPI.get_world())
	deregistered.emit()
	
	#MultiplayerApi.client2server(
		#InvPickupPacket.create_drop(MultiplayerApi.peer_id, ResPreloader.ITEM.GUN)
	#)

#func _multiplayer_register(cam_path: NodePath, anchor_path: NodePath):
	## We have to pass in paths, because the path will be different for different clients. Also, not serializeable otherwise
	#var anchor: Marker3D = get_node(anchor_path)
	#var camera: Camera3D = get_node(cam_path)
	#root_obj.reparent(anchor)
	#root_obj.global_rotation = Vector3.ZERO
	#
	## Get the difference between the objs zero point and the desired grab pos
	#var offset = (root_obj.global_position - root_obj.handle_marker.global_position)
	#
	#proc_func = func():
		#root_obj.global_rotation = camera.global_rotation
		##root_obj.global_position = anchor.global_position
		#root_obj.global_position = (anchor.global_position + offset)
#
#func _multiplayer_deregister():
	#root_obj.reparent(WorldAPI.get_world())
	#proc_func = NULL_FUNC

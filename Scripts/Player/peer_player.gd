extends BasePlayer

func _ready():
	#print("in peer")
	basic_setup()
	#camera.current = false

# so, every peer_player has a cooresponding ctrl_player
# so we need to have peer_player be linked to the properties of its corresponding ctrler
# but, how do we link if the node isnt local? 
# well, we could add a sync to both the ctrl and peer and cross link them 
# I dont think we can

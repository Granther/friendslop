extends Grabbable

func _ready():
	_runtime_checks()
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_leftm_key_hit = Callable(self, "_on_leftm")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

func _on_inter():
	pass
	#if armed:
		#item_comp.on_drop_key_hit.call()
	#else: # We are not armed, but its in our hand
		#pass
		
func _on_leftm():
	print("fifre")
		
func _on_drop():
	interaction_area.set_label_visible(true)
	item_comp.player_ref.item_manager.drop_item()

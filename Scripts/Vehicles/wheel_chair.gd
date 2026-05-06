extends Rideable

func _ready():
	_runtime_checks()
	item_comp.on_drop_key_hit = Callable(self, "_on_drop")
	item_comp.on_inter_key_hit = Callable(self, "_on_inter")
	item_comp.on_register = Callable(self, "_on_register")
	item_comp.on_deregister = Callable(self, "_on_deregister")

func _on_register():
	pass # get in
	
func _on_deregister():
	pass # get out

func _on_inter():
	pass # speed up

func _on_drop():
	pass

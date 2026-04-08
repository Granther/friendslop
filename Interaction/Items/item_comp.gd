extends Node3D

@export var is_grab: bool

var prep_drop: Callable = func():
	pass

var prep_grab: Callable = func():
	pass

func is_grabbable():
	return is_grab

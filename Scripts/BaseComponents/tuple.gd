extends RefCounted
class_name Tuple

var vals: Array[Variant]

func _init(...args: Array[Variant]): 
	vals = args
	
func unload(...args):
	for i in range(len(args)):
		args[i] = vals[i]

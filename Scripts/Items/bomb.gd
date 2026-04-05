extends Node3D

@onready var bomb = $Bomb

func _ready():
	var c = bomb.get_children()
	#for i in c:
		#if i.name == "Fuse":
			#i.hide()

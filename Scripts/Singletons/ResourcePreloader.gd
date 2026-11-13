extends Node

# the idea is a singleton autoload that preloads all the inv items at runtime, since reousrces are only accessed once

@onready var gun: Resource = preload("res://Scripts/Equippables/hitscan_gun.gd")

enum ITEM {
	GUN = 0,
}

var items_dict: Dictionary = {
	ITEM.GUN: gun,
}

func _ready() -> void:
	pass

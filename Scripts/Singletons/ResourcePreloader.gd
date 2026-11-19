extends Node

# the idea is a singleton autoload that preloads all the inv items at runtime, since reousrces are only accessed once

@onready var gun: PackedScene = preload("res://Scenes/Equippables/hitscan_gun_inv.tscn")
@onready var vis_gun: PackedScene = preload("res://Scenes/Visuals/hitscan_gun_vis.tscn")

enum ITEM { NONE, GUN }
enum VISUAL { NONE, GUN }

@onready var items_dict: Dictionary = {
	ITEM.GUN: gun,
}

@onready var visuals_dict: Dictionary = {
	VISUAL.GUN: vis_gun,
}

func _ready() -> void:
	pass

class_name TileManager extends Node2D


@export var level : int = -1
var tile_maplayer : TileMapLayer
var cells : Array[Vector2i] = []

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is TileMapLayer:
			tile_maplayer = child
			break

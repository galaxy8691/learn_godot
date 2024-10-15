extends Node

class_name GridManager

@export var highlight_tile_maplayer : TileMapLayer
func _ready() -> void:
	pass # Replace with function body.

func update_highlight_tile_maplayer(grid_vector : Vector2i, radius : int) -> void:
	clear_highlight_tile_maplayer()
	for x in range(grid_vector.x - radius, grid_vector.x + radius + 1):
		for y in range(grid_vector.y-radius, grid_vector.y + radius + 1):
			highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func clear_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()

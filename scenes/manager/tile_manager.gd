class_name TileManager extends Node2D


@export var level : int = -1
var tile_maplayer : TileMapLayer
var occupied_cells : Array[Vector2i] = []

func _ready() -> void:
	var children = get_children()
	for child in children:
		if child is TileMapLayer:
			tile_maplayer = child
			break

func add_cell(cell : Vector2i):
	occupied_cells.append(cell)

func get_cell_tile_data(cell : Vector2i):
	return tile_maplayer.get_cell_tile_data(cell)

func has_cell(cell : Vector2i):
	return cell in occupied_cells

func check_cell_is_buildable(cell : Vector2i):
	if !has_cell(cell):
		return false
	var tile_data = get_cell_tile_data(cell)
	return tile_data.get_custom_data("buildable")

func check_cells_in_occupied_cells(cells : Array[Vector2i]):
	for cell in cells:
		if !has_cell(cell):
			return false
	return true

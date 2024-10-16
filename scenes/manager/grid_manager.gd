extends Node

class_name GridManager

@export var highlight_tile_maplayer : TileMapLayer
@export var base_tile_maplayer : TileMapLayer
var occupied_cells = {}
func _ready() -> void:
	pass # Replace with function body.

func highlight_buildable_area():
	clear_highlight_tile_maplayer()
	var building_components = get_tree().get_nodes_in_group("building_component") as Array[BuildingComponent]
	for building_component in building_components:
		_update_highlight_tile_maplayer(building_component.get_grid_cell_position(), building_component.buildable_radius)

func _update_highlight_tile_maplayer(grid_vector : Vector2i, radius : int) -> void:
	for x in range(grid_vector.x - radius, grid_vector.x + radius + 1):
		for y in range(grid_vector.y-radius, grid_vector.y + radius + 1):
			if !check_cell_is_valid_to_build(Vector2i(x,y)):
				continue
			highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func clear_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()

func add_occpied_cell(cell : Vector2i):
	occupied_cells[cell] = true

func check_cell_is_valid_to_build(cell : Vector2i):
	var custome_data = base_tile_maplayer.get_cell_tile_data(cell)
	if custome_data == null:
		return false
	if !custome_data.get_custom_data("buildable"):
		return false
	return !occupied_cells.has(cell)
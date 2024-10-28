extends TileMapLayer
class_name CellTileMapLayer
@export var level : int = -1
var occupied_cells : Array[Vector2i] = []
# Called when the node enters the scene tree for the first time.
func add_cell(cell : Vector2i):
	occupied_cells.append(cell)


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

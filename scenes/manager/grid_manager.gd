extends Node

class_name GridManager

@export var highlight_tile_maplayer : TileMapLayer
@export var base_tile_maplayer : TileMapLayer

var valid_buildable_cells = []
func _ready() -> void:
	GameEvent.instance.building_placed.connect(_on_building_placed)

func highlight_buildable_area():
	clear_highlight_tile_maplayer()
	var building_components = get_tree().get_nodes_in_group("building_component") as Array[BuildingComponent]
	for building_component in building_components:
		_update_highlight_tile_maplayer(building_component.get_grid_cell_position(), building_component.buildable_radius)
		
func _update_highlight_tile_maplayer(grid_vector : Vector2i, radius : int) -> void:
	for x in range(grid_vector.x - radius, grid_vector.x + radius + 1):
		for y in range(grid_vector.y-radius, grid_vector.y + radius + 1):
			if !_check_cell_is_not_occupied(Vector2i(x,y)):
				continue
			highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func update_valid_buildable_cells(buildable_compoent: BuildingComponent):
	#valid_buildable_cells.clear()
	print(valid_buildable_cells)
	var root_cell = buildable_compoent.get_grid_cell_position()
	for x in range(root_cell.x - buildable_compoent.buildable_radius, root_cell.x + buildable_compoent.buildable_radius + 1):
		for y in range(root_cell.y - buildable_compoent.buildable_radius, root_cell.y + buildable_compoent.buildable_radius + 1):
			if _check_cell_is_not_occupied(Vector2i(x,y)) && !check_cell_is_in_buiding_area(Vector2i(x,y)):
				valid_buildable_cells.append(Vector2i(x,y))
				#highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func clear_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()

func _check_cell_is_not_occupied(cell : Vector2i):
	var custome_data = base_tile_maplayer.get_cell_tile_data(cell)
	if custome_data == null:
		return false
	return custome_data.get_custom_data("buildable")

func _add_building_to_building_area(building_component: BuildingComponent):
	valid_buildable_cells.remove_at(valid_buildable_cells.find(building_component.get_grid_cell_position()))

func check_cell_is_in_buiding_area(cell : Vector2i):
	return cell in valid_buildable_cells

func _on_building_placed(building_component : BuildingComponent):
	update_valid_buildable_cells(building_component)
	_add_building_to_building_area(building_component)
	
extends Node

class_name GridManager

@export var highlight_tile_maplayer : TileMapLayer
@export var base_tile_maplayer : TileMapLayer

var valid_buildable_cells = []
var highlight_expand_cells = []
var tile_maplayers = []
var collected_resource = []
var new_collected_resource = []
func _ready() -> void:
	GameEvent.instance.building_placed.connect(_on_building_placed)
	tile_maplayers = _setup_tile_maplayers(base_tile_maplayer)

# func highlight_buildable_area():
# 	clear_highlight_tile_maplayer()
# 	for cell in valid_buildable_cells:
# 		highlight_tile_maplayer.set_cell(cell, 0,Vector2i(0,0))

func highlight_area(grid_vector: Vector2i, build_radius: int, resource_radius: int):
	highlight_expand_cells.clear()
	highlight_tile_maplayer.clear()
	for x in range(grid_vector.x - build_radius, grid_vector.x + build_radius + 1):
		for y in range(grid_vector.y-build_radius, grid_vector.y + build_radius + 1):
			if !_check_cell_is_buildable_tile(Vector2i(x,y)):
				continue
			highlight_expand_cells.append(Vector2i(x,y))
	for x in range(grid_vector.x - resource_radius, grid_vector.x + resource_radius + 1):
		for y in range(grid_vector.y-resource_radius, grid_vector.y + resource_radius + 1):
			if !_check_cell_is_wood_tile(Vector2i(x,y)):
				continue
			var i = collected_resource.find(Vector2i(x,y))
			if i == -1:
				highlight_expand_cells.append(Vector2i(x,y))
	for cell in highlight_expand_cells:
		highlight_tile_maplayer.set_cell(cell, 0,Vector2i(1,0))
	for cell in valid_buildable_cells:
		highlight_tile_maplayer.set_cell(cell, 0,Vector2i(0,0))

func _check_cell_is_wood_tile(cell : Vector2i):
	for tile_maplayer in tile_maplayers:
		var custome_data = tile_maplayer.get_cell_tile_data(cell)
		if custome_data == null:
			continue
		return custome_data.get_custom_data("wood")
	return false

func _update_collected_resource(buildable_compoent: BuildingComponent):
	var root_cell = buildable_compoent.get_grid_cell_position()
	for x in range(root_cell.x - buildable_compoent.resource_radius, root_cell.x + buildable_compoent.resource_radius + 1):
		for y in range(root_cell.y - buildable_compoent.resource_radius, root_cell.y + buildable_compoent.resource_radius + 1):
			if _check_cell_is_wood_tile(Vector2i(x,y)):
				if collected_resource.find(Vector2i(x,y)) == -1:
					collected_resource.append(Vector2i(x,y))
					new_collected_resource.append(Vector2i(x,y))

func get_new_collected_resource_point():
	var point = len(new_collected_resource)
	new_collected_resource.clear()
	return point

# func _update_highlight_tile_maplayer(grid_vector : Vector2i, radius : int) -> void:
# 	for x in range(grid_vector.x - radius, grid_vector.x + radius + 1):
# 		for y in range(grid_vector.y-radius, grid_vector.y + radius + 1):
# 			if !_check_cell_is_buildable_tile(Vector2i(x,y)):
# 				continue
# 			highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func _update_valid_buildable_cells(buildable_compoent: BuildingComponent):
	#valid_buildable_cells.clear()
	var root_cell = buildable_compoent.get_grid_cell_position()
	for x in range(root_cell.x - buildable_compoent.buildable_radius, root_cell.x + buildable_compoent.buildable_radius + 1):
		for y in range(root_cell.y - buildable_compoent.buildable_radius, root_cell.y + buildable_compoent.buildable_radius + 1):
			if _check_cell_is_buildable_tile(Vector2i(x,y)) && !check_cell_is_in_buiding_area_and_not_occupied(Vector2i(x,y)):
				valid_buildable_cells.append(Vector2i(x,y))
				#highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func clear_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()

func _check_cell_is_buildable_tile(cell : Vector2i):
	for tile_maplayer in tile_maplayers:
		var custome_data = tile_maplayer.get_cell_tile_data(cell)
		if custome_data == null:
			continue
		return custome_data.get_custom_data("buildable")
	return false


func _setup_tile_maplayers(tile_maplayer : TileMapLayer) -> Array[TileMapLayer]:
	var array : Array[TileMapLayer] = []
	for child in tile_maplayer.get_children():
		if child is TileMapLayer:
			array.append_array(_setup_tile_maplayers(child))
	array.append(tile_maplayer)
	return array


func _remove_building_from_building_area():
	var building_components = get_tree().get_nodes_in_group("building_component") as Array[BuildingComponent]
	for building in building_components:
		valid_buildable_cells.remove_at(valid_buildable_cells.find(building.get_grid_cell_position()))

func check_cell_is_in_buiding_area_and_not_occupied(cell : Vector2i):
	return cell in valid_buildable_cells

func _on_building_placed(building_component : BuildingComponent):
	_update_valid_buildable_cells(building_component)
	_update_collected_resource(building_component)
	_remove_building_from_building_area()
	
extends Node

class_name GridManager

@export var highlight_tile_maplayer : TileMapLayer
#@export var base_tile_maplayer : TileMapLayer
@export var tile_managers : Array[TileManager] = []
@export var resource_tile_maplayer : TileMapLayer
@export var base_tile_manager : TileManager
var valid_buildable_cells = []
var placed_buildings = []
var highlight_expand_cells = []
var tile_maplayers = []
var collected_resource = []
var new_collected_resource = []
func _ready() -> void:
	GameEvent.instance.building_placed.connect(_on_building_placed)
	GameEvent.instance.building_destroyed.connect(_on_building_destroyed)
	_setup_tile_managers()
	

# func highlight_buildable_area():
# 	clear_highlight_tile_maplayer()
# 	for cell in valid_buildable_cells:
# 		highlight_tile_maplayer.set_cell(cell, 0,Vector2i(0,0))

func highlight_expand_area(grid_vector: Vector2i,  building_component: BuildingComponent):
	highlight_expand_cells.clear()
	var build_radius = building_component.buildable_radius
	var resource_radius = building_component.resource_radius
	var occupation_size = building_component.occupation_size
	for x in range(grid_vector.x - build_radius, grid_vector.x + build_radius  + occupation_size.x):
		for y in range(grid_vector.y-build_radius, grid_vector.y + build_radius  + occupation_size.y):
			if !_check_cell_is_buildable_tile(Vector2i(x,y)):
				continue
			highlight_expand_cells.append(Vector2i(x,y))
	for x in range(grid_vector.x - resource_radius, grid_vector.x + resource_radius  + occupation_size.x):
		for y in range(grid_vector.y-resource_radius, grid_vector.y + resource_radius  + occupation_size.y):
			if !_check_cell_is_wood_tile(Vector2i(x,y)):
				continue
			var i = collected_resource.find(Vector2i(x,y))
			if i == -1:
				highlight_expand_cells.append(Vector2i(x,y))
	for cell in highlight_expand_cells:
		highlight_tile_maplayer.set_cell(cell, 0,Vector2i(1,0))

func highlight_area():
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
	var cells : Array[Vector2i] = buildable_compoent.get_resource_cells()
	for cell in cells:
		if _check_cell_is_wood_tile(cell):
			if collected_resource.find(cell) == -1:
				collected_resource.append(cell)
				new_collected_resource.append(cell)

func get_new_collected_resource_point():
	var point = len(new_collected_resource)
	new_collected_resource.clear()
	return point


func _update_valid_buildable_cells():
	valid_buildable_cells.clear()
	for building_component in placed_buildings:
		var cells : Array[Vector2i] = building_component.get_buildable_cells()
		for cell in cells:
			if _check_cell_is_buildable_tile(cell) && Vector2i(cell.x,cell.y) not in valid_buildable_cells:
				valid_buildable_cells.append(cell)
	_remove_building_from_building_area()


func clear_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()

func _check_cell_is_buildable_tile(cell : Vector2i):
	var result = true
	for tile_maplayer in tile_maplayers:
		var custome_data = tile_maplayer.get_cell_tile_data(cell)
		if custome_data == null:
			continue
		if custome_data.get_custom_data("ignore"):
			continue    
		if !custome_data.get_custom_data("buildable"):
			result = false
			break
	return result


func _setup_tile_managers():   
	var base_rect = base_tile_manager.get_node("TileMapLayer").get_used_rect()
	var start_cell = base_rect.position
	var end_cell = base_rect.end
	for x in range(start_cell.x, end_cell.x):
		for y in range(start_cell.y, end_cell.y):
			var cell = Vector2i(x,y)
			var valid_for_managers = []
			for i in range(len(tile_managers)):
				if tile_managers[i].get_cell_tile_data(cell) != null:
					valid_for_managers.append(i)
			if valid_for_managers.size() > 1:
				var max_i = valid_for_managers[0]
				for i in valid_for_managers:
					if tile_managers[i].level > tile_managers[max_i].level:
						max_i = i
				tile_managers[max_i].add_cell(cell)
	return null


func _remove_building_from_building_area():
	for building in placed_buildings:
		var cells : Array[Vector2i] = building.get_occupation_cells()
		for cell in cells:
			valid_buildable_cells.remove_at(valid_buildable_cells.find(cell))

func check_cell_is_in_buiding_area_and_not_occupied(cell : Vector2i, area_size : Vector2i):
	var result = true
	for x in range(cell.x, cell.x + area_size.x):
		for y in range(cell.y, cell.y + area_size.y):
			if Vector2i(x,y) not in valid_buildable_cells:
				result = false
				break
	return result

func _on_building_placed(building_component : BuildingComponent):
	_add_placed_building(building_component)
	_update_valid_buildable_cells()
	_update_collected_resource(building_component)

func _on_building_destroyed(building_component : BuildingComponent):
	_remove_placed_building(building_component)
	_update_valid_buildable_cells()

func _remove_placed_building(building_component: BuildingComponent):
	placed_buildings.remove_at(placed_buildings.find(building_component))

func _add_placed_building(building_component: BuildingComponent):
	placed_buildings.append(building_component)

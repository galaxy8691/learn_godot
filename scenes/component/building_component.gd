class_name BuildingComponent extends Node2D

@export var buildable_radius : int 
@export var resource_radius : int
@export var resource_uasage : int
@export var occupation_size : Vector2i
@export var deletable : bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("building_component")
	GameEvent.emit_building_placed(self)

func get_grid_cell_position() -> Vector2i:
	return global_position / 64

func get_grid_cell_area() -> Rect2i:
	var cell_position = get_grid_cell_position()
	return Rect2i(cell_position.x, cell_position.y, occupation_size.x, occupation_size.y)

func get_occupation_cells() -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var cell_area = get_grid_cell_area()
	for x in range(cell_area.position.x, cell_area.end.x):
		for y in range(cell_area.position.y, cell_area.end.y):
			cells.append(Vector2i(x,y))
	return cells

func get_resource_cells() -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var cell_area = get_grid_cell_area()
	for x in range(cell_area.position.x - resource_radius, cell_area.end.x + resource_radius ):
		for y in range(cell_area.position.y - resource_radius, cell_area.end.y + resource_radius ):
			cells.append(Vector2i(x,y))
	return cells

func get_buildable_cells() -> Array[Vector2i]:
	var cells : Array[Vector2i] = []
	var cell_area = get_grid_cell_area()
	for x in range(cell_area.position.x - buildable_radius, cell_area.end.x + buildable_radius ):
		for y in range(cell_area.position.y - buildable_radius, cell_area.end.y + buildable_radius ):
			cells.append(Vector2i(x,y))
	return cells

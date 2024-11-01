class_name BuildingComponent extends Node2D

@export var buildable_radius : int 
@export var resource_radius : int
@export var resource_uasage : int
@export var danger_radius : int
@export var occupation_size : Vector2i
@export var deletable : bool = true


@export var control_type : BuildingConstant.ControlType = BuildingConstant.ControlType.BUILDABLE


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


func get_control_cells() -> Array[Vector2i]:
	var radius = 0
	if control_type == BuildingConstant.ControlType.BUILDABLE:
		radius = buildable_radius
	elif control_type == BuildingConstant.ControlType.RESOURCE:
		radius = resource_radius
	elif control_type == BuildingConstant.ControlType.DANGER:
		radius = danger_radius
	var cells : Array[Vector2i] = []
	var cell_area = get_grid_cell_area()
	for x in range(cell_area.position.x - radius, cell_area.end.x + radius ):
		for y in range(cell_area.position.y - radius, cell_area.end.y + radius ):
			cells.append(Vector2i(x,y))
	return cells

func check_cell_is_in_control_area(cell: Vector2i) -> bool:
	var control_cells = get_control_cells()
	return control_cells.has(cell)
	

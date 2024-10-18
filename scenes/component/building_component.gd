class_name BuildingComponent extends Node2D

@export var buildable_radius : int 
@export var resource_radius : int
@export var resource_uasage : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("building_component")
	GameEvent.emit_building_placed(self)

func get_grid_cell_position() -> Vector2i:
	return global_position / 64


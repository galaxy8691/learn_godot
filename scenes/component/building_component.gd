class_name BuildingComponent extends Node2D

@export var buildable_radius : int 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("building_component")

func get_grid_cell_position() -> Vector2i:
	return global_position / 64


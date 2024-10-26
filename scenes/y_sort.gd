extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var buildings : Array[BuildingComponent] = []
	for child in get_children():
		if child.get_node("BuildingComponent"):
			buildings.append(child.get_node("BuildingComponent"))
	GameEvent.emit_initial_buildings_ready(buildings)

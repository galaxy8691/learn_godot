class_name GameEvent extends Node

signal building_placed(building_compoent : BuildingComponent)
signal building_destroyed(building_compoent : BuildingComponent)
signal initial_buildings_ready(buildings : Array[BuildingComponent])
signal resource_changed(resource : int)
signal ask_resource_point()
static var instance : GameEvent
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _notification(what: int) -> void:
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		instance = self

static func emit_building_placed(building_component : BuildingComponent) -> void:
	instance.building_placed.emit(building_component)

static func emit_building_destroyed(building_component : BuildingComponent) -> void:
	instance.building_destroyed.emit(building_component)

static func emit_initial_buildings_ready(buildings : Array[BuildingComponent]) -> void:
	instance.initial_buildings_ready.emit(buildings)

static func emit_resource_changed(resource : int) -> void:
	instance.resource_changed.emit(resource)

static func emit_ask_resource_point() -> void:
	instance.ask_resource_point.emit()

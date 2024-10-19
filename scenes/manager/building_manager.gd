extends Node


enum State {
	Normal,
	Building
}
var tower : PackedScene = load("res://scenes/building/tower.tscn")
var villiage : PackedScene = load("res://scenes/building/villiage.tscn")
@export var ysort : Node2D
@export var grid_manager : GridManager
var build_radius = 3
var resource_radius = 3
var current_building_instance = null;
var place_building_type = "tower" # tower or villiage
@export var cursor : BuildingGhost
var hover_grid_position : Vector2i = Vector2i.MAX
@export var ui : UI
var current_resource = 4
var current_state : State = State.Normal

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cursor.visible = false
	cursor.set_invalid()
	ui.place_tower.connect(func ():
		_on_place_building_press("tower")
	)
	ui.place_villiage.connect(func ():
		_on_place_building_press("villiage")
	)

func _on_place_building_press(type : String) -> void:
	place_building_type = type
	if current_state == State.Normal:
		cursor.visible = true
		current_state = State.Building
		grid_manager.clear_highlight_tile_maplayer()
		cursor.set_building_type(type)
		if place_building_type == "tower":
			_on_place_tower_press()
		elif place_building_type == "villiage":
			_on_place_villiage_press()
		_set_build_and_resource_radius(current_building_instance)
	else:
		cancel_place_building()
		

func _on_place_tower_press():
	current_building_instance = tower.instantiate()

func _on_place_villiage_press():
	current_building_instance = villiage.instantiate()
	

func _set_build_and_resource_radius(building_instance):
	var builiding_component = building_instance.get_node("BuildingComponent")
	build_radius = builiding_component.buildable_radius
	resource_radius = builiding_component.resource_radius

func _unhandled_input(event: InputEvent) -> void:
	if current_state == State.Building:
		if event.is_action_pressed("left_click") && hover_grid_position != Vector2i.MAX \
		&& grid_manager.check_cell_is_in_buiding_area_and_not_occupied(hover_grid_position) \
		&& current_resource >= current_building_instance.get_node("BuildingComponent").resource_uasage:
			current_resource -= current_building_instance.get_node("BuildingComponent").resource_uasage
			place_building(current_building_instance)
			current_resource += grid_manager.get_new_collected_resource_point()
			current_building_instance = null
			cursor.visible = false
			current_state = State.Normal
		if event.is_action_pressed("cancel"):
			cancel_place_building()
	if current_state == State.Normal:
		if event.is_action_pressed("right_click"):
			var building = get_building_at_position()
			if building:
				GameEvent.emit_building_destroyed(building.get_node("BuildingComponent"))
				destroy_building(building)

func place_building(building_instance):
	building_instance.global_position = hover_grid_position * 64
	ysort.add_child(building_instance)
	grid_manager.clear_highlight_tile_maplayer()





func get_mouse_grid_cell_position() -> Vector2i:
	var mouse_position = cursor.get_global_mouse_position()
	var grid_position = mouse_position / 64
	grid_position = grid_position.floor()
	return grid_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	hover_grid_position = get_mouse_grid_cell_position()
	if current_state == State.Normal:
		grid_manager.clear_highlight_tile_maplayer()
	elif current_state == State.Building:
		grid_manager.clear_highlight_tile_maplayer()
		if !grid_manager.check_cell_is_in_buiding_area_and_not_occupied(hover_grid_position):
			cursor.set_invalid()
		else:
			cursor.set_valid()
			grid_manager.highlight_expand_area(hover_grid_position, build_radius, resource_radius)
		grid_manager.highlight_area()	
	cursor.global_position = hover_grid_position * 64

func cancel_place_building():
	current_state = State.Normal
	cursor.visible = false
	if current_building_instance != null:
		grid_manager.remove_placed_building(current_building_instance.get_node("BuildingComponent"))
		current_building_instance.queue_free()
		current_building_instance = null
		grid_manager.clear_highlight_tile_maplayer()

func destroy_building(building):
		var resource_point = building.get_node("BuildingComponent").resource_uasage
		building.queue_free()
		current_resource += resource_point
		grid_manager.clear_highlight_tile_maplayer()

func get_building_at_position():
	var building_components = get_tree().get_nodes_in_group("building_component") as Array[BuildingComponent]
	for building_component in building_components:
		if building_component.get_grid_cell_position() == hover_grid_position:
			return building_component.get_parent()
	return null

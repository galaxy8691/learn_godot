extends Node


# Called when the node enters the scene tree for the first time.
var cursor : Sprite2D
var tower : PackedScene = load("res://scenes/building/tower.tscn")
var villiage : PackedScene = load("res://scenes/building/villiage.tscn")
var p_tower_button : Button
var p_villiage_button : Button
var hover_grid_position : Vector2i = Vector2i.MAX
var grid_manager : GridManager
var ysort : Node2D
var place_building_type = "tower" # tower or villiage
var build_radius = 3
var resource_radius = 3
var current_building_instance = null;
func _ready() -> void:
	grid_manager = $GridManager
	ysort = $YSort
	cursor = $Cursor
	cursor.visible = false
	p_tower_button = $PlaceTowerButton
	p_villiage_button = $PlaceVilliageButton
	p_tower_button.pressed.connect(_on_place_tower_press)
	p_villiage_button.pressed.connect(_on_place_villiage_press)
   
func _on_place_tower_press():
	cursor.visible = !cursor.visible
	grid_manager.clear_highlight_tile_maplayer()
	place_building_type = "tower"
	current_building_instance = tower.instantiate()
	_set_build_and_resource_radius(current_building_instance)

func _on_place_villiage_press():
	cursor.visible = !cursor.visible
	grid_manager.clear_highlight_tile_maplayer()
	place_building_type = "villiage"
	current_building_instance = villiage.instantiate()
	_set_build_and_resource_radius(current_building_instance)

func _set_build_and_resource_radius(building_instance):
	var builiding_component = building_instance.get_node("BuildingComponent")
	build_radius = builiding_component.buildable_radius
	resource_radius = builiding_component.resource_radius

func _unhandled_input(event: InputEvent) -> void:
	if cursor.visible && event.is_action_pressed("left_click") && hover_grid_position != Vector2i.MAX \
	&& grid_manager.check_cell_is_in_buiding_area_and_not_occupied(hover_grid_position):
		place_building(current_building_instance)
		current_building_instance = null
		cursor.visible = false


func place_building(building_instance):
	building_instance.global_position = hover_grid_position * 64
	ysort.add_child(building_instance)
	grid_manager.clear_highlight_tile_maplayer()

# func place_villiage():
# 	var building_instance = villiage.instantiate()
# 	building_instance.global_position = hover_grid_position * 64
# 	var builidjng_component = building_instance.get_node("BuildingComponent")
# 	build_radius = builidjng_component.buildable_radius
# 	resource_radius = builidjng_component.resource_radius
# 	ysort.add_child(building_instance)
# 	grid_manager.clear_highlight_tile_maplayer()

# func place_tower():
# 	var building_instance = tower.instantiate()
# 	building_instance.global_position = hover_grid_position * 64
# 	var builidjng_component = building_instance.get_node("BuildingComponent")
# 	build_radius = builidjng_component.buildable_radius
# 	resource_radius = builidjng_component.resource_radius
# 	ysort.add_child(building_instance)
# 	grid_manager.clear_highlight_tile_maplayer()

func get_mouse_grid_cell_position() -> Vector2i:
	var mouse_position = cursor.get_global_mouse_position()
	var grid_position = mouse_position / 64
	grid_position = grid_position.floor()
	return grid_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hover_grid_position = get_mouse_grid_cell_position()
	if(cursor.visible):
		grid_manager.highlight_area(hover_grid_position, build_radius, resource_radius)
	
	cursor.global_position = hover_grid_position * 64
	#grid_manager.highlight_buildable_area()

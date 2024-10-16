extends Node


# Called when the node enters the scene tree for the first time.
var cursor : Sprite2D
var building : PackedScene = load("res://scenes/building/building.tscn")
var p_button : Button
var hover_grid_position : Vector2i = Vector2i.MAX
var grid_manager : GridManager

func _ready() -> void:
	grid_manager = $GridManager
	cursor = $Cursor
	cursor.visible = false
	p_button = $PlaceBuildingButton
	p_button.pressed.connect(on_press)
   
func on_press():
	cursor.visible = !cursor.visible

func _unhandled_input(event: InputEvent) -> void:
	if cursor.visible && event.is_action_pressed("left_click") && hover_grid_position != Vector2i.MAX && grid_manager.check_cell_is_valid_to_build(hover_grid_position):
		placce_building()
		cursor.visible = false



func placce_building():

	var building_instance = building.instantiate()
	add_child(building_instance)
	grid_manager.add_occpied_cell(hover_grid_position)
	building_instance.global_position = hover_grid_position * 64
	grid_manager.clear_highlight_tile_maplayer()

func get_mouse_grid_cell_position() -> Vector2:
	var mouse_position = cursor.get_global_mouse_position()
	var grid_position = mouse_position / 64
	grid_position = grid_position.floor()
	return grid_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	hover_grid_position = get_mouse_grid_cell_position()
	cursor.global_position = hover_grid_position * 64
	if cursor.visible && hover_grid_position != Vector2i.MAX:
		grid_manager.update_highlight_tile_maplayer(hover_grid_position, 3)

extends Node


# Called when the node enters the scene tree for the first time.
var cursor : Sprite2D
var building : PackedScene = load("res://scenes/building/building.tscn")
var p_button : Button
var hover_grid_position : Vector2i = Vector2i.MAX
var highlight_tile_maplayer : TileMapLayer
var occupied_cells = {}
func _ready() -> void:
	highlight_tile_maplayer = $HighlightTileMapLayer
	cursor = $Cursor
	cursor.visible = false
	p_button = $PlaceBuildingButton
	p_button.pressed.connect(on_press)

func on_press():
	cursor.visible = !cursor.visible

func _unhandled_input(event: InputEvent) -> void:
	if cursor.visible && event.is_action_pressed("left_click") && hover_grid_position != Vector2i.MAX && !occupied_cells.has(hover_grid_position):
		placce_building()
		cursor.visible = false

func update_highlight_tile_maplayer():
	highlight_tile_maplayer.clear()
	if hover_grid_position == Vector2i.MAX:
		return
	else:
		#print(hover_grid_position)
		for x in range(hover_grid_position.x - 3, hover_grid_position.x + 4):
			for y in range(hover_grid_position.y-3, hover_grid_position.y+4):
				highlight_tile_maplayer.set_cell(Vector2i(x,y), 0,Vector2i(0,0))

func placce_building():

	var building_instance = building.instantiate()
	add_child(building_instance)
	occupied_cells[hover_grid_position] = true
	building_instance.global_position = hover_grid_position * 64
	highlight_tile_maplayer.clear()

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
		update_highlight_tile_maplayer()

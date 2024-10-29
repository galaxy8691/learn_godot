extends Node
class_name BaseLevel

var gold_mine : GoldMine
var camera : GlobalCamera
var base_tilemaplayer : CellTileMapLayer
var base : Node2D
var ui : CanvasLayer
var win_button_section : CanvasLayer
var building_ghost : Node2D
var tween : Tween = null
var current_mouse_cell_position : Vector2i = Vector2i(0,0)

func _ready():
	gold_mine = %GoldMine
	camera = $GlobalCamera
	base_tilemaplayer = %BaseTileMapLayer
	base = %Base
	ui = $Ui
	win_button_section = $WinButtonSection
	camera.set_boudery(base_tilemaplayer.get_used_rect())
	building_ghost = %BuildingGhost
	camera.center_on_base(base.global_position)
	GameEvent.instance.building_placed.connect(_on_building_placed)

func _on_building_placed(building_compoent : BuildingComponent):
	var gold_mine_position_building_component = gold_mine.get_node("BuildingComponent")
	var gold_mine_occupation_cells = gold_mine_position_building_component.get_occupation_cells()
	var building_buildable_cells = building_compoent.get_buildable_cells()
	for cell in building_buildable_cells:
		if cell in gold_mine_occupation_cells:
			_win()
			break

func _win():
	gold_mine.set_active()
	ui.visible = false
	win_button_section.visible = true

func _process(_delta: float) -> void:
	# if tween != null:
	# 	tween.kill()
	# 	tween = null
	move_building_ghost()
	
func move_building_ghost():
	var mouse_position = base.get_global_mouse_position()
	var mouse_cell_position = mouse_position / 64 as Vector2i
	if current_mouse_cell_position != mouse_cell_position:
		current_mouse_cell_position = mouse_cell_position
		mouse_cell_position = mouse_cell_position as Vector2
		tween = create_tween()
		tween.tween_property(building_ghost, "global_position", mouse_cell_position * 64, 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# building_ghost.global_position = mouse_cell_position * 64

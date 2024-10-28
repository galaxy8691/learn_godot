extends Node
class_name BaseLevel

var gold_mine : GoldMine
var camera : GlobalCamera
var base_tilemaplayer : CellTileMapLayer
var base : Node2D

func _ready():
	gold_mine = %GoldMine
	camera = $GlobalCamera
	base_tilemaplayer = %BaseTileMapLayer
	base = %Base
	camera.set_boudery(base_tilemaplayer.get_used_rect())
	
	camera.center_on_base(base.global_position)
	GameEvent.instance.building_placed.connect(_on_building_placed)

func _on_building_placed(building_compoent : BuildingComponent):
	var gold_mine_position_building_component = gold_mine.get_node("BuildingComponent")
	var gold_mine_occupation_cells = gold_mine_position_building_component.get_occupation_cells()
	var building_buildable_cells = building_compoent.get_buildable_cells()
	for cell in building_buildable_cells:
		if cell in gold_mine_occupation_cells:
			gold_mine.set_active()
			break

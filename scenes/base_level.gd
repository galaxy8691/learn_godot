extends Node


var gold_mine : GoldMine
var camera : GlobalCamera
var base_tilemaplayer : TileMapLayer

func _ready():
	gold_mine = %GoldMine
	camera = $GlobalCamera
	base_tilemaplayer = %BaseTileMapLayer
	camera.set_boudery(base_tilemaplayer.get_used_rect())
	GameEvent.instance.building_placed.connect(_on_building_placed)

func _on_building_placed(building_compoent : BuildingComponent):
	var gold_mine_position = gold_mine.global_position
	gold_mine_position = (Vector2i) (gold_mine_position / 64)
	var building_position = building_compoent.get_grid_cell_position()
	var building_range = building_compoent.buildable_radius    
	for x in range(building_position.x - building_range, building_position.x + building_range + 1):
		for y in range(building_position.y - building_range, building_position.y + building_range + 1):
			if gold_mine_position == Vector2i(x,y):
				gold_mine.set_active()          
				return
			else:
				gold_mine.set_inactive()


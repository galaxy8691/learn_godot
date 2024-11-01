extends Node2D

class_name BuildingGhost

var tower_sprite : Sprite2D
var villiage_sprite : Sprite2D
var is_valid : bool = false
var top_right_sprite : Sprite2D
var bottom_left_sprite : Sprite2D
var bottom_right_sprite : Sprite2D
var current_type : BuildingConstant.BuildingType = BuildingConstant.BuildingType.TOWER
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower_sprite = $TowerSprite
	villiage_sprite = $VilliageSprite
	top_right_sprite = $TopRightSprite2D
	bottom_left_sprite = $BottomLeftSprite2D
	bottom_right_sprite = $BottomRightSprite2D

func set_building_type(type : BuildingConstant.BuildingType) -> void:
	if type == BuildingConstant.BuildingType.TOWER:
		current_type = BuildingConstant.BuildingType.TOWER
		tower_sprite.visible = true
		villiage_sprite.visible = false
		top_right_sprite.position = Vector2(2*64,0)
		bottom_left_sprite.position = Vector2(0,2*64)
		bottom_right_sprite.position = Vector2(2*64,2*64)
	elif type == BuildingConstant.BuildingType.VILLIAGE:
		current_type = BuildingConstant.BuildingType.VILLIAGE
		tower_sprite.visible = false
		villiage_sprite.visible = true
		top_right_sprite.position = Vector2(2*64,0)
		bottom_left_sprite.position = Vector2(0,2*64)
		bottom_right_sprite.position = Vector2(2*64,2*64)
		

func set_invalid() -> void:
	is_valid = false
	modulate = Color(1,0,0)


func set_valid() -> void:
	is_valid = true
	modulate = Color(1,1,1)

func get_building_offset() -> Vector2:
	if current_type == BuildingConstant.BuildingType.TOWER:
		return Vector2(1*32,1*64)
	elif current_type == BuildingConstant.BuildingType.VILLIAGE:
		return Vector2(1*32,1*64)
	return Vector2(0,0)

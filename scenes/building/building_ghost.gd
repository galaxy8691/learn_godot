extends Node2D

class_name BuildingGhost

var tower_sprite : Sprite2D
var villiage_sprite : Sprite2D
var is_valid : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tower_sprite = $TowerSprite
	villiage_sprite = $VilliageSprite

func set_building_type(type : String) -> void:
	if type == "tower":
		tower_sprite.visible = true
		villiage_sprite.visible = false
	else:
		tower_sprite.visible = false
		villiage_sprite.visible = true

func set_invalid() -> void:
	is_valid = false
	modulate = Color(1,0,0)


func set_valid() -> void:
	is_valid = true
	modulate = Color(1,1,1)

extends Node2D

class_name GoldMine
var gold_mine_active_sprite : Sprite2D
var gold_mine_inactive_sprite : Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gold_mine_active_sprite = $GoldMineActiveSprite
	gold_mine_inactive_sprite = $GoldMineInactiveSprite


func set_active() -> void:
	print("Setting gold mine to active")
	gold_mine_active_sprite.visible = true
	gold_mine_inactive_sprite.visible = false

func set_inactive() -> void:
	gold_mine_active_sprite.visible = false
	gold_mine_inactive_sprite.visible = true

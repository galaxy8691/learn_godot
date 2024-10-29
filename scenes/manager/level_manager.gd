extends Node
class_name LevelManager

static var instance : LevelManager
@export var levels : Array[PackedScene] = []
var current_level_index : int = 0
signal win_all_levels()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _notification(what: int) -> void:
	if what == NOTIFICATION_SCENE_INSTANTIATED:
		instance = self


static func change_level(level_index: int):
	instance.current_level_index = level_index
	instance.get_tree().change_scene_to_packed(instance.levels[level_index])

static func change_to_next_level():
	if instance.current_level_index + 1 < instance.levels.size():
		change_level(instance.current_level_index + 1)
	else:
		print("Win all levels")
		instance.win_all_levels.emit()

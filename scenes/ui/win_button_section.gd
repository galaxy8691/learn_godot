extends CanvasLayer

var button : Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button = %Button
	button.connect("pressed", func():
		LevelManager.change_to_next_level()
		)


# Called every frame. 'delta' is the elapsed time since the previous frame.


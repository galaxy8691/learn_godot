extends CanvasLayer


var play_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play_button = %PlayButton
	play_button.connect("pressed", func():
		LevelManager.change_level(0)
		)

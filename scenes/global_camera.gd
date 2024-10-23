extends Camera2D

class_name GlobalCamera

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_position = get_screen_center_position()	
	var movement_vector = Input.get_vector("pan_left", "pan_right", "pan_up", "pan_down")
	global_position += movement_vector * 500 * delta
	

func set_boudery(boudery_rect : Rect2):
	limit_left = boudery_rect.position.x * 64
	limit_right = boudery_rect.end.x * 64
	limit_top = boudery_rect.position.y * 64
	limit_bottom = boudery_rect.end.y * 64

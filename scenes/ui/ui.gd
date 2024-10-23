extends CanvasLayer

class_name  UI

signal place_tower
signal place_villiage

@onready var place_tower_button : Button = %PlaceTowerButton
@onready var place_villiage_button : Button = %PlaceVilliageButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	place_tower_button.pressed.connect(func ():
		self.place_tower.emit())
	place_villiage_button.pressed.connect(func ():
		self.place_villiage.emit())

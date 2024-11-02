extends CanvasLayer

class_name  UI

signal place_tower
signal place_villiage
signal place_barracks

var villiage_build_button_section : BuildButtonSection
var tower_build_button_section : BuildButtonSection
var barrack_build_button_section : BuildButtonSection
var resource_label : Label

# @onready var place_tower_button : Button = %PlaceTowerButton
# @onready var place_villiage_button : Button = %PlaceVilliageButton

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	villiage_build_button_section = %VilliageBuildButtonSection
	tower_build_button_section = %TowerBuildButtonSection
	barrack_build_button_section = %BarrackBuildButtonSection
	resource_label = %ResourceLabel
	villiage_build_button_section.build_button_pressed.connect(func ():
		self.place_villiage.emit())
	tower_build_button_section.build_button_pressed.connect(func ():
		self.place_tower.emit())
	barrack_build_button_section.build_button_pressed.connect(func ():
		self.place_barracks.emit())
	GameEvent.instance.resource_changed.connect(func (resource : int):
		resource_label.text = str(resource)
	)
	GameEvent.emit_ask_resource_point()

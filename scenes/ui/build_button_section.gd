extends PanelContainer

class_name BuildButtonSection
@export var building_name : String
@export var resource_cost : int
@export var description : String
var building_name_label : Label
var resource_cost_label : Label
var description_label : Label
var build_button : Button
signal build_button_pressed

func _ready():
	building_name_label = %BuildingNameLabel
	building_name_label.text = building_name
	resource_cost_label = %ResourceCostLabel
	resource_cost_label.text = str(resource_cost)
	description_label = %DescriptionLabel
	description_label.text = description
	build_button = %BuildButton
	build_button.pressed.connect(func():
		build_button_pressed.emit())

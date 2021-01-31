extends Control
var shovelOptions
var currentSelection = 0
var numberOfOptions = 3

func _ready():
	shovelOptions = $ShovelOptions
	shovelOptions.add_item("Color1", load("res://Inventory/Items/Bomb.png"))
	shovelOptions.add_item("Color2", load("res://Inventory/Items/Bomb.png"))
	shovelOptions.add_item("Color3", load("res://Inventory/Items/Bomb.png"))

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		currentSelection -= 1
		if currentSelection < 0:
			currentSelection = numberOfOptions - 1
	if(Input.is_action_just_pressed("ui_down")):
		currentSelection = (currentSelection + 1) % numberOfOptions
	shovelOptions.select(currentSelection)


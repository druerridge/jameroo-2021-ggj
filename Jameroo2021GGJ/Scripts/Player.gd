extends "res://Scripts/Actor.gd"

export(NodePath) var gui_path = "GUI"
onready var gui = get_node(gui_path)
onready var shovelOptionsArea = $Pivot/CanvasLayer/ShovelOptionsUI/ShovelOptions

# every attempt dig will change or add the dug sprite
# inputs H, J, K will select a color to dig
# Shift digs, using the color
# Y, U, I will select a shape that will be used
# space will place
# we might want to talk about the UX of doing these things

var drunkTimer = 0

func _ready():
	obj_color = CELL_COLORS.RED

func _process(delta):
	if Input.is_action_just_pressed("ui_shovel"):
		shovelOptionsArea.visible = not shovelOptionsArea.visible
	obj_color = shovelOptionsArea.items[shovelOptionsArea.currentSelection]
	if shovelOptionsArea.visible:
		return
	
	if drunkTimer > 0:
		drunkTimer -= delta
	elif drunkTimer > -1:
		drunkTimer = -1
		InputSystem.reset_movement_inputs()
	
	if InputSystem.input_activation:
		activate_object()
	if InputSystem.input_direction:
		target_position(InputSystem.input_direction)
	if Input.is_action_just_pressed("ui_inventory"):
		$InventoryComponent.toggle_window(self)
	if Input.is_action_just_pressed("action_dig"):
		attempt_dig()


# Make a vector of the direction we're facing, then ask the grid to interact
# with whatever is there
func activate_object():
	var direction_of_interaction = Vector2((int(dir == DIR.RIGHT) - int(
			dir == DIR.LEFT)), (int(dir == DIR.DOWN) - int(dir == DIR.UP)))
	overworld.request_interaction(self, direction_of_interaction)

func _on_item_interacted(sender, item):
	if not correct_shovel_color(sender):
		print("not the correct color")
		return
	if $InventoryComponent.add_to_inventory(item, 1):
		sender.queue_free()
		overworld.remove_from_active(sender)
		overworld.check_if_won()

func correct_shovel_color(sender):
	return sender.obj_color == CELL_COLORS.NONE || sender.obj_color == self.obj_color

func attempt_dig():
	overworld.request_interaction(self, Vector2.ZERO)
	
func start_dig():
	var should_dig = yield()
	if should_dig:
		attempt_dig()

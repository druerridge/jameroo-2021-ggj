extends "res://Scripts/Actor.gd"

export(NodePath) var gui_path = "GUI"
onready var gui = get_node(gui_path)
export(NodePath) var shovel_gui_path = "Shovel_GUI"
onready var shovel_gui = get_node(shovel_gui_path)

export(Script) var initial_shovel

var drunkTimer = 0

var obj_color_to_color = {
	CELL_COLORS.YELLOW: "yellow",
	CELL_COLORS.BLUE: "blue",
	CELL_COLORS.PURPLE: "purple"
}

func _ready():
	obj_color = CELL_COLORS.YELLOW
	var newItem = initial_shovel.new("yellow")
	$ShovelInvComponent.add_to_inventory(newItem, 1)

func _process(delta):
	if Input.is_action_just_pressed("ui_shovel"):
		$ShovelInvComponent.toggle_window(self)
	
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
	if Input.is_action_just_pressed("mark_tri"):
		var marking_color = obj_color_to_color[obj_color]
		overworld.spawn_marking(marking_color, "tri", self.position)
	if Input.is_action_just_pressed("mark_x"):
		var marking_color = obj_color_to_color[obj_color]
		overworld.spawn_marking(marking_color, "x", self.position)
	if Input.is_action_just_pressed("mark_o"):
		var marking_color = obj_color_to_color[obj_color]
		overworld.spawn_marking(marking_color, "o", self.position)
	if Input.is_action_just_pressed("unmark"):
		overworld.unspawn_marking(self.position)
		
# Make a vector of the direction we're facing, then ask the grid to interact
# with whatever is there
func activate_object():
	var direction_of_interaction = Vector2((int(dir == DIR.RIGHT) - int(
			dir == DIR.LEFT)), (int(dir == DIR.DOWN) - int(dir == DIR.UP)))
	overworld.request_interaction(self, Vector2.ZERO)

func _on_item_interacted(sender, item):
	if item.i_name == "Shovel":
		if $ShovelInvComponent.inv_query(item.i_name, 1) && $ShovelInvComponent.add_to_inventory(item, 1):
			sender.queue_free()
			overworld.remove_from_active(sender)
	elif $InventoryComponent.add_to_inventory(item, 1):
		sender.queue_free()
		overworld.remove_from_active(sender)
		overworld.check_if_won()

func correct_shovel_color(sender):
	return sender.obj_color == CELL_COLORS.NONE || sender.obj_color == self.obj_color

func attempt_dig():
	overworld.attempt_dig(self)
	
func start_dig():
	var should_dig = yield()
	if should_dig:
		attempt_dig()
func get_gui(caller):
	if "Shovel" in caller:
		return shovel_gui
	return gui

func set_shovel_color(color):
	color = color.to_upper()
	if color == CELL_COLORS.keys()[1]:
		obj_color = CELL_COLORS.YELLOW
	if color == CELL_COLORS.keys()[2]:
		obj_color = CELL_COLORS.BLUE
	if color == CELL_COLORS.keys()[3]:
		obj_color = CELL_COLORS.PURPLE

func use_a_key_return_sucess():
	var index = $InventoryComponent.get_inv_index("Key")
	var has_more_than_one = $InventoryComponent.inv_query("Key", 1)
	if index > -1 && has_more_than_one:
		$InventoryComponent.use_item_at_slot(index)
		return true
	return false

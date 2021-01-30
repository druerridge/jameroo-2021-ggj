extends "res://Scripts/Actor.gd"

export(NodePath) var gui_path = "GUI"
onready var gui = get_node(gui_path)

func _process(delta):
	if InputSystem.input_activation:
		activate_object()
	elif InputSystem.input_direction:
		target_position(InputSystem.input_direction)
	elif Input.is_action_just_pressed("ui_inventory"):
		$InventoryComponent.toggle_window(self)
	elif Input.is_action_just_pressed("action_dig"):
		attempt_dig()


# Make a vector of the direction we're facing, then ask the grid to interact
# with whatever is there
func activate_object():
	var direction_of_interaction = Vector2((int(dir == DIR.RIGHT) - int(
			dir == DIR.LEFT)), (int(dir == DIR.DOWN) - int(dir == DIR.UP)))
	overworld.request_interaction(self, direction_of_interaction)

func attempt_dig():
	overworld.request_interaction(self, Vector2.ZERO)
	
func _on_item_interacted(sender, item):
	if $InventoryComponent.add_to_inventory(item, 1):
		sender.queue_free()

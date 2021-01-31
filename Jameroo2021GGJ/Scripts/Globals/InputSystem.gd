extends Node

var input_direction
var input_activation

var default_movement_inputs = [ "ui_up", "ui_right", "ui_down", "ui_left" ]
var current_movement_inputs = []

func _ready():
	# Do not disable this when game is paused
	set_pause_mode(PAUSE_MODE_PROCESS)
	reset_movement_inputs()


func _process(delta):
	input_direction = get_input_direction()
	input_activation = get_input_activation()


func get_input_direction():
	var horizontal = int(Input.is_action_pressed(current_movement_inputs[1])) - int(Input.is_action_pressed(current_movement_inputs[3]))
	var vertical = int(Input.is_action_pressed(current_movement_inputs[2])) - int(Input.is_action_pressed(current_movement_inputs[0]))
	return Vector2(horizontal, vertical if horizontal == 0 else 0)


func get_input_activation():
	return Input.is_action_just_pressed("ui_accept")

func randomize_movement_inputs():
	current_movement_inputs.shuffle()

func reset_movement_inputs():
	current_movement_inputs = default_movement_inputs

# Extremely useful for things like stopping "interact" from looping
# E.G. actor displays dialog, "interact" is the same button that closes dialog
# It would also, on the same frame, trigger interact again
func neutralize_inputs():
	input_direction = null
	input_activation = null


# Give other systems the ability to disable ALL input until a given trigger
# Useful for things like letting menu animations or scene transitions finish
func disable_input_until(wait_for_this_object, to_finish_this):
	neutralize_inputs()
	set_process(false)
	yield(wait_for_this_object, to_finish_this)
	set_process(true)


# Just for "game over"
func disable_input():
	neutralize_inputs()
	set_process(false)

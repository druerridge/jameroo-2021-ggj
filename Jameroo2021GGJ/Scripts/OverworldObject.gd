extends Node2D

onready var overworld = get_parent()

enum CELL_TYPES { ACTOR, OBJECT, DIGGABLE }
enum CELL_COLORS {NONE, YELLOW, BLUE, PURPLE}
export(CELL_TYPES) var obj_type = CELL_TYPES.OBJECT
export (CELL_COLORS) var obj_color = CELL_COLORS.NONE

func do_what_this_object_does():
	pass
	
func interact():
	pass

# An object can specify its condition for being preent in the scene by defining
# this method. By default, if an actor is present in the editor, it will be
# present in game.
func spawn_condition():
	return true

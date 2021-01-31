extends Node2D

onready var overworld = get_parent()

enum CELL_TYPES { ACTOR, OBJECT, DIGGABLE }
enum CELL_COLORS {NONE, Color1, Color2, Color3}
export(CELL_TYPES) var obj_type = CELL_TYPES.OBJECT
export (CELL_COLORS) var obj_color = CELL_COLORS.NONE

func do_what_this_object_does():
	print(name, " is an OverworldObject that doesn't do anything.")
	
func interact():
	print("Default, please override me")

# An object can specify its condition for being preent in the scene by defining
# this method. By default, if an actor is present in the editor, it will be
# present in game.
func spawn_condition():
	return true

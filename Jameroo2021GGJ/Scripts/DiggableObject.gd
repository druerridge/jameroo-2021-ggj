extends "res://Scripts/OverworldObject.gd"

onready var sprite = $Pivot/Sprite

export(Script) var itemDirectory
export var dug_frame = 0
export var not_dug_frame = 1

signal interact(sender, item)

var item

func _ready():
	#$Pivot/Sprite.visible = false
	if not itemDirectory == null:
		item = itemDirectory.new()

func interact():
	if($Pivot/Sprite.visible == true):
		emit_signal("interact", self, item)
	$Pivot/Sprite.visible = true

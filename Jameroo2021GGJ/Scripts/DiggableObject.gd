extends "res://Scripts/OverworldObject.gd"

onready var sprite = $Pivot/Sprite

export(Script) var itemDirectory
export var dug_frame = 0
export var not_dug_frame = 1

signal interacted(sender, item)

var item

func _ready():
	$Pivot/Sprite.visible = false
	if not itemDirectory == null:
		item = itemDirectory.new()


func interact():
	emit_signal("interacted", self, item if $Pivot/Sprite.visible == true else null)
	$Pivot/Sprite.visible = true

extends "res://Scripts/OverworldObject.gd"

export var shape: String = "nocolor"
export var color: String = "noshape"

func _ready():
	if (color + "-" + shape != "nocolor-noshape"):
		$AnimatedSprite.animation = color + "-" + shape
		$AnimatedSprite.play()
	else:
		self.hide()
	

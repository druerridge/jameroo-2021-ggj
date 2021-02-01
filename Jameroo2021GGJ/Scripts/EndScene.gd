extends Node2D

var end_scene = true

func _ready():
	var globals = get_node("/root/Globals")
	if (globals.get("won") != null and globals.won):
		$RoomCode.text = "You've beaten John the Wick after " + str(globals.attempts) + " attempts!"
	else:
		$RoomURL.text = $BackendControl.get_share_url()

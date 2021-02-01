extends Node2D

func _ready():
	$RoomURL.text = $BackendControl.get_share_url()

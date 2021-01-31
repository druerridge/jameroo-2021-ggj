extends Node2D

func _on_JoinRoom_pressed():
	if $RoomInput.text.empty:
		return
	$BackendControl.get_room($RoomInput.text)
	get_tree().change_scene("res://Demo/GGJ.tscn")

func _on_NewRoom_pressed():
	pass

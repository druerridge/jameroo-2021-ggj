class_name IItem
extends Node


var i_name := "ItemName"
var i_image: StreamTexture = load("res://icon.png")
var i_description := "Short Description"
var i_color := "NONE"
var i_consumable := true
var i_stackable := true
var i_maxstack := 5

func i_use(_player):
	return false
func i_pickup(_player):
	pass

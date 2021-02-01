extends Node2D

var player
var min_distance
signal gameover()

func _ready():
	player = get_tree().get_nodes_in_group("Player")
	min_distance = 5

func _process(delta):
	if !player:
		return
	if is_close_to_player():
		print("game is over")
		emit_signal("gameover")

func is_close_to_player():
	var distance = position.distance_to(player.position)
	return distance <= min_distance

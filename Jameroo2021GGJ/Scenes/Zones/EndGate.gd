extends Node2D

var player
var min_distance
var gameover_signal_sent
var keys_used
var timer

signal gameover()

func _ready():
	min_distance = 120
	gameover_signal_sent = false
	keys_used = 0
	timer = 0

func _process(delta):
	if !player:
		player = get_tree().get_nodes_in_group("Player")[0]
		return
	if timer > 0:
		timer -= delta
	if is_close_to_player() && timer <= 0:
		if player.use_a_key_return_sucess():
			keys_used += 1
			$Position2D/AnimatedSprite.animation = str(keys_used)
			timer = 2
		if keys_used >= 2:
			gameover_signal_sent = true
			emit_signal("gameover")

func is_close_to_player():
	if gameover_signal_sent == true:
		return false
	var distance = position.distance_to(player.position)
	return distance <= min_distance

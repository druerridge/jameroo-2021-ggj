extends Node

# temp for testing until we get a game timer that triggers this
var time = 0
func _process(delta):
	time += delta
	if time > 10 and not $Layer2.playing:
		play_layer_2()
	if time > 20 and not $Layer3.playing:
		play_layer_3()

func play_layer_2():
	var playbackPosition = $Layer1.get_playback_position()
	$Layer2.play(playbackPosition)

func play_layer_3():
	var playbackPosition = $Layer1.get_playback_position()
	$Layer3.play(playbackPosition)

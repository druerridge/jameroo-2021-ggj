extends Node

var FADE_IN_INITIAL_VOLUME = -80
var FADE_IN_DURATION_SECONDS = 2
var FADE_IN_DELAY_SECONDS = 0
		
func is_layer_2_playing():
	return $Layer2.playing

func play_layer_2():
	var playbackPosition = $Layer1.get_playback_position()
	fade_in_layer($Layer2, playbackPosition)

func is_layer_3_playing():
	return $Layer3.playing

func play_layer_3():
	var playbackPosition = $Layer1.get_playback_position()
	fade_in_layer($Layer3, playbackPosition)
	
func fade_in_layer(layer, playbackPosition):
	var finalVolume = layer.volume_db
	layer.volume_db = FADE_IN_INITIAL_VOLUME
	
	$VolumeTween.interpolate_property(
		layer,
		"volume_db",
		FADE_IN_INITIAL_VOLUME,
		finalVolume,
		FADE_IN_DURATION_SECONDS,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN,
		FADE_IN_DELAY_SECONDS);
	$VolumeTween.start()
	
	layer.play(playbackPosition)

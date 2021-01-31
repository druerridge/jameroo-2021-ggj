extends Node

var LEVEL_LENGTH_SECONDS = 30
var VISIBLE_LIGHT_MINIMUM_SCALE = Vector2(0.2, 0.2)

var elapsedTimeSeconds = 0
var isFirstFrame = true

var backgroundMusic
var visibleLight: Node2D
var visibleLightInitialScale: Vector2

func _process(delta):
	if isFirstFrame:
		initialize()
		isFirstFrame = false
	
	elapsedTimeSeconds += delta
	
	if elapsedTimeSeconds > LEVEL_LENGTH_SECONDS:
		end_game()
	else:
		layer_background_music()
		dim_lighting()

func initialize():
	# i'm sure there's a better way to do this
	backgroundMusic = get_parent().get_node("BackgroundMusic")
	visibleLight = get_parent().get_node("InteractiveTerrain").get_node("Player").get_node("Pivot").get_node("VisibleLight2D")
	visibleLightInitialScale = visibleLight.scale

func end_game():
	get_tree().change_scene("res://Scenes/Zones/EndScene.tscn")

func layer_background_music():
	var oneThirdTime = LEVEL_LENGTH_SECONDS / 3
	if elapsedTimeSeconds > oneThirdTime and not backgroundMusic.is_layer_2_playing():
		backgroundMusic.play_layer_2()
		
	var twoThirdsTime = LEVEL_LENGTH_SECONDS / 3 * 2
	if elapsedTimeSeconds > twoThirdsTime and not backgroundMusic.is_layer_3_playing():
		backgroundMusic.play_layer_3()

func dim_lighting():
	visibleLight.scale = visibleLightInitialScale.linear_interpolate(VISIBLE_LIGHT_MINIMUM_SCALE, elapsedTimeSeconds / LEVEL_LENGTH_SECONDS)

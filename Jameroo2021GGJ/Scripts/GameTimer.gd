extends Node

var LEVEL_LENGTH_SECONDS = 180
var VISIBLE_LIGHT_MINIMUM_SCALE = Vector2(0.4, 0.4)

var elapsedTimeSeconds = 0
var isFirstFrame = true
var ended

var backgroundMusic
var visibleLight: Node2D
var visibleLightInitialScale: Vector2

func _process(delta):
	if Input.is_action_pressed("end_game"):
		end_game(false)
	
	if isFirstFrame:
		initialize()
		isFirstFrame = false
	
	elapsedTimeSeconds += delta
	
	if elapsedTimeSeconds > LEVEL_LENGTH_SECONDS:
		end_game(false)
	else:
		layer_background_music()
		dim_lighting()
		
func initialize():
	# i'm sure there's a better way to do this
	backgroundMusic = get_parent().get_node("BackgroundMusic")
	visibleLight = get_parent().get_node("InteractiveTerrain").get_node("Player").get_node("Pivot").get_node("VisibleLight2D")
	visibleLightInitialScale = visibleLight.scale

func end_game(won):
	if (ended == true):
		return
	ended = true
	
	print("ending game")
	var scene = get_parent()
	var overworld = scene.get_node("InteractiveTerrain")
	
	print("origin room data: " + str(overworld.origin_room_data))
	var backend_control = scene.get_node("BackendControl")
	get_node("/root/Globals").won = won
	overworld.origin_room_data.room.attempts = overworld.origin_room_data.room.attempts + 1
	get_node("/root/Globals").attempts = overworld.origin_room_data.room.attempts
	if (won):
		overworld.origin_room_data.room.finishedBy = "cats"
	backend_control.update_room(backend_control.room_id, overworld.origin_room_data)

func layer_background_music():
	var oneThirdTime = LEVEL_LENGTH_SECONDS / 3
	if elapsedTimeSeconds > oneThirdTime and not backgroundMusic.is_layer_2_playing():
		backgroundMusic.play_layer_2()
		
	var twoThirdsTime = LEVEL_LENGTH_SECONDS / 3 * 2
	if elapsedTimeSeconds > twoThirdsTime and not backgroundMusic.is_layer_3_playing():
		backgroundMusic.play_layer_3()

func dim_lighting():
	visibleLight.scale = visibleLightInitialScale.linear_interpolate(VISIBLE_LIGHT_MINIMUM_SCALE, elapsedTimeSeconds / LEVEL_LENGTH_SECONDS)

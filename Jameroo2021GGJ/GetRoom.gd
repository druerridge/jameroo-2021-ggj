extends Node

# Declare member variables here. Examples:
# var base_url = "http://localhost:10999/roomState/"
var base_url = "http://ggj2021.maestrosgame.com/roomState/"
var roomId = ""
var roomData = {}

# var b = "text"
func _ready():
	roomId = tryGetRoomIdFromUrl()
	print("ready")

func tryGetRoomIdFromUrl():
	if OS.has_feature('JavaScript'):
		var temp_hostname = JavaScript.eval("window.location.hostname")
		var temp_pathname = JavaScript.eval("window.location.pathname")
		print("hostname: " + temp_hostname)
		print("pathname: " + temp_hostname)
		
	else:
		print("The JavaScript singleton is NOT available")

func _on_GetRoomButton_pressed():
	var url = base_url + $RoomdIdTextEdit.text
	$GetRoomHTTPRequest.request(url)
	print("Requested from " + url)

func _on_request_completed(result, response_code, headers, body):
	if (response_code > 299 || response_code < 200):
		print("error on http request complete")	
		$RoomDataRichTextLabel.text = "error on http request complete"
	var jsonString = body.get_string_from_utf8();
	var json = JSON.parse(jsonString)
	roomData = json.result
	print(json.result)	
	$RoomDataRichTextLabel.text = jsonString

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_UpdateRoomButton_pressed():
	pass # Replace with function body.

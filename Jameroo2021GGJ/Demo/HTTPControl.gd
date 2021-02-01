extends Control


# Declare member variables here. Examples:
# var base_url = "http://localhost:10999/roomState/"
var base_url = "http://ggj2021.maestrosgame.com/roomState/"
var roomData = {}

# var b = "text"
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	print("ready")

func _on_Button_pressed():
	var url = base_url + $TextEdit.text
	$HTTPRequest.request(url)
	print("Requested from " + url)

func _on_request_completed(result, response_code, headers, body):
	if (response_code > 299 || response_code < 200):
		print("error on http request complete")	
		$RoomDataRichTextLabel.text = "error on http request complete"
	var jsonString = body.get_string_from_utf8();
	var json = JSON.parse(jsonString)
	roomData = json.result
	#print(json.result)	
	$RoomDataRichTextLabel.text = jsonString


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Control


# Declare member variables here. Examples:
# var base_url = "http://localhost:10999/roomState/"
var base_url = "http://ggj2021.maestrosgame.com/roomState/"

# var b = "text"
func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	print("ready")

func _on_Button_pressed():
	
	var url = base_url + $TextEdit.text
	$HTTPRequest.request(url)
	print("Requested from " + url)

func _on_request_completed(result, response_code, headers, body):
	var jsonString = body.get_string_from_utf8();
	var json = JSON.parse(jsonString)
	print(json.result)	
	$RichTextLabel.text = jsonString


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

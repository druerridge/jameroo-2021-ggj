extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")
	print("ready")

func _on_Button_pressed():
	var url = "http://localhost:10999/roomState/room22"
	$HTTPRequest.request(url)
	print("Requested from " + url)

func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	$Button.text = "Done"
	print(json.result)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

extends Control

signal room_data_loaded(room_data)

var get_room_base_url = "UNDEFINED YO"
var base_url = "http://ggj2021.maestrosgame.com/" # for testing w/ remote backend (default)
#var base_url = "http://localhost:10999/" # for testing with a local backend
var room_id = ""
var room_data

func _ready():
	initialize()
	print("ready")
	get_room(room_id)

func js_initialize():
	if OS.has_feature('JavaScript'):
		var temp_hostname = JavaScript.eval("window.location.hostname")
		var temp_pathname = JavaScript.eval("window.location.pathname")
		var temp_search = JavaScript.eval("window.location.search")
		var temp_href = JavaScript.eval("window.location.href")
		var temp_port = JavaScript.eval("window.location.port")

		var temp_room_id = JavaScript.eval("""
				var parameterName = "id";
				var result = null,
					tmp = [];
				location.search
					.substr(1)
					.split("&")
					.forEach(function (item) {
					  tmp = item.split("=");
					  if (tmp[0] === parameterName) result = decodeURIComponent(tmp[1]);
					});
				result;
		""")
		
		print("hostname: " + temp_hostname)
		print("pathname: " + temp_pathname)
		print("search: " + temp_search)
		print("href: " + temp_href)
		print("port: " + temp_port)
		base_url = temp_href.rstrip(temp_search)

		if (temp_room_id != null or temp_room_id != ""):
			print("temp_room_id: " + temp_room_id)
			room_id = temp_room_id
	else:
		print("The JavaScript singleton is NOT available")

func initialize():
	js_initialize()
	get_room_base_url = base_url + "roomState/"
	print("room_id: " + room_id)
	print("base_url: " + base_url)
	print("get_room_base_url: " + get_room_base_url)

func get_share_url():
	return base_url + "?id=" + get_node("/root/Globals").room_id

func get_room(in_room_id):
	var url = get_room_base_url + in_room_id
	var http_request = HTTPRequest.new()
#	http_request.set_name("")
	http_request.connect("request_completed", self, "_on_get_room_completed")
	add_child(http_request)
	
	print("Requesting from " + url)
	http_request.request(url)

func update_room(in_room_id, in_room_data):
	var payload = JSON.print(in_room_data)
	var headers = ["Content-Type: application/json"]
	
	var url = get_room_base_url + in_room_id
	var http_request = HTTPRequest.new()
#	http_request.set_name("")
	http_request.connect("request_completed", self, "_on_update_room_completed")
	add_child(http_request)
	
	print("Requesting from " + url)
	http_request.request(url, headers, false, HTTPClient.METHOD_POST, payload)

func _on_update_room_completed(result, response_code, headers, body):
	if (result != 0):
		print("Unsuccessful POST request. result: " + result)
		$RoomDataRichTextLabel.text = "error making request to server"
	
	if (response_code > 299 || response_code < 200):
		print("error on POST http request complete. response_code: " + response_code)
		$RoomDataRichTextLabel.text = "error on http request complete"
	
	var jsonString = body.get_string_from_utf8()
	print("successfully updated room. response payload:" +  jsonString)
	$RoomDataRichTextLabel.text = "Room successfully updated. Response was: " + jsonString
	get_tree().change_scene("res://Scenes/Zones/EndScene.tscn")

func _on_get_room_completed(result, response_code, headers, body):
	if (result != 0):
		print("Unsuccessful GET request. result: " + result)
		$RoomDataRichTextLabel.text = "error making request to server"
	
	if (response_code > 299 || response_code < 200):
		print("error on GET http request complete. response_code: " + response_code)
		$RoomDataRichTextLabel.text = "error on http request complete"
		
	var jsonString = body.get_string_from_utf8();
	var json := JSON.parse(jsonString)
	room_data = json.result
	if (room_data.room.get("roomId")):
		room_id = room_data.room.roomId
		get_node("/root/Globals").room_id = room_id
	print(json.result)
	$RoomDataRichTextLabel.text = jsonString
	emit_signal("room_data_loaded", room_data)

func _on_GetRoomButton_pressed():
	get_room($RoomIdTextEdit.text);

func _on_UpdateRoomButton_pressed():
	print("UpdateRoomButton pressed")
	update_room($RoomIdTextEdit.text, room_data)


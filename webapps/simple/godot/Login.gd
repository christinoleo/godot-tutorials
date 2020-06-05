extends Control


onready var user = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/user
onready var password = $PanelContainer/MarginContainer/VBoxContainer/GridContainer/password
onready var http_request = HTTPRequest.new()

func _ready():
	# Create an HTTP request node and connect its completion signal.
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	var response = parse_json(body.get_string_from_utf8())
	print(response)


func _on_Button_pressed():
	# Perform the HTTP request. The URL below returns some JSON as of writing.
	var fields = {"username" : user.text, "password" : password.text}
	var result = http_request.request("http://127.0.0.1:5000/login", PoolStringArray(['Content-Type: application/json']), false, 2, to_json(fields))
	if result != OK:
		push_error("An error occurred in the HTTP request.")

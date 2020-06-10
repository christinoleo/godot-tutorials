extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var access_key = <your access key>
var secret_key = <your secret key>

# Called when the node enters the scene tree for the first time.
func _ready():
#	$DynamoDB.call_dynamodb(access_key, secret_key)
	var call = {
		"TableName": "test",
	}
	
	$DynamoDB.call_dynamodb(access_key, secret_key, call, "DynamoDB_20120810.Scan")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_DynamoDB_response(result, response_code, headers, body):
	print(response_code)
	print(body)
	
	
	

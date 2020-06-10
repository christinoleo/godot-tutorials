extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var my_name := ""
var leaderboard := {}

var default_num_lives := 1
var num_lives := 1
var score := 0


var access_key = <your access key>
var secret_key = <your secret key>

# Called when the node enters the scene tree for the first time.
func _ready():
#	load_save()
	
	DynamoDb.connect("response", self, "_on_DynamoDB_response")
	var call = {
		"TableName": "test",
	}
	
	DynamoDb.call_dynamodb(access_key, secret_key, call, "DynamoDB_20120810.Scan")

func _on_DynamoDB_response(result, response_code, headers, body):
	print(response_code)
	body = parse_json(body)
	print(body)
	
	if not "Items" in body:
		return
	
	for item in body["Items"]:
		leaderboard[item["player"]["S"]] = int(item["score"]["N"])


func get_leaderboard() -> Array:
	var ret = []
	for k in leaderboard.keys():
		ret.append({"name": k, "score": leaderboard[k]})
	ret.sort_custom(self, "sort_ascending")
	return ret

func new_score():
	num_lives = default_num_lives
	if not my_name in leaderboard or leaderboard[my_name] < score:
		leaderboard[my_name] = score
	
		DynamoDb.connect("response", self, "_on_DynamoDB_response")
		var call = {
			"TableName": "test",
			"Item": {
				"game": {
					"S": "platform"
				},
				"player": {
					"S": my_name
				},
				"score": {
					"N": String(score)
				}
			},
		}
		
		DynamoDb.call_dynamodb(access_key, secret_key, call, "DynamoDB_20120810.PutItem")

	

func reset_score():
	score = 0	

	
func sort_ascending(a, b):
	if a["score"] > b["score"]:
		return true
	return false
	
	
func save():
	var data_to_save := {"leaderboard": leaderboard}
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(to_json(data_to_save))
	save_game.close()
	
	
func load_save():
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		return # Error! We don't have a save to load.
	
	save_game.open("user://savegame.save", File.READ)
	var saved_data = parse_json(save_game.get_line())
	leaderboard = saved_data["leaderboard"]
	save_game.close()


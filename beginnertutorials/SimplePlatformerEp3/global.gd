extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var leaderboard := []

var default_num_lives := 1
var num_lives := 1
var score := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	load_save()


func new_score():
	leaderboard.append(score)
	leaderboard.sort_custom(self, "sort_ascending")
	num_lives = default_num_lives
	save()
	

func reset_score():
	score = 0	

	
func sort_ascending(a, b):
	if a > b:
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


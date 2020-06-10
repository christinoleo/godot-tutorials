extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var lives_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/NLives
onready var score_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/score
onready var leaderboard_panel = $LeaderboardPanel/MarginContainer/VBoxContainer
onready var leaderboard_panel_container = $LeaderboardPanel


# Called when the node enters the scene tree for the first time.
func _ready():
	update_ui()

func update_ui():
	lives_label.text = String(Global.num_lives)
	score_label.text = String(Global.score)
	
	for c in leaderboard_panel.get_children():
		leaderboard_panel.remove_child(c)
		
	var max_scores := min(Global.leaderboard.size(), 10)
	for i in range(max_scores):
		var score = Global.leaderboard[i]
		var label = Label.new()
		label.text = String(score)
		leaderboard_panel.add_child(label)
	
func show_leaderboard():
	leaderboard_panel_container.show()
	
func hide_leaderboard():
	leaderboard_panel_container.hide()

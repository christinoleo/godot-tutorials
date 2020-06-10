extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var lives_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer/NLives
onready var score_label = $Panel/MarginContainer/VBoxContainer/HBoxContainer2/score
onready var leaderboard_panel = $LeaderboardPanel/MarginContainer/VBoxContainer
onready var leaderboard_panel_container = $LeaderboardPanel
onready var panel_name = $PanelName
onready var panel_name_edit = $PanelName/MarginContainer/CenterContainer/VBoxContainer/HBoxContainer/LineEdit


# Called when the node enters the scene tree for the first time.
func _ready():
	update_ui()

func update_ui():
	lives_label.text = String(Global.num_lives)
	score_label.text = String(Global.score)
		
	
func show_leaderboard():
	if Global.num_lives <= 0 and Global.my_name != "":
		Global.new_score()
	if Global.my_name == "": panel_name.show()
	
	for c in leaderboard_panel.get_children():
		leaderboard_panel.remove_child(c)
		
	var leaderboard:Array = Global.get_leaderboard()
	var max_scores := min(leaderboard.size(), 10)
	for i in range(max_scores):
		var score = leaderboard[i]
		var label = Label.new()
		label.text = String(score["name"]) + ": " + String(score["score"])
		leaderboard_panel.add_child(label)
		
	leaderboard_panel_container.show()
	
	
func hide_leaderboard():
	leaderboard_panel_container.hide()


func _on_set_name_pressed():
	Global.my_name = panel_name_edit.text
	Global.new_score()
	panel_name.hide()
	update_ui()

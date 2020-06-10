extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var next_level := "res://level1.tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var camera = $mainchar/Camera2D
onready var character = $mainchar
onready var main_gui = $CanvasLayer/MainGui


func _on_goal_body_entered(body):
	Global.score += 1000
	$CanvasLayer/CenterContainer/youwin.show()
	$CanvasLayer/CenterContainer/youwin.trigger()



func _on_deathpit_death_detected(from, to):
	to.queue_free()
	if not $CanvasLayer/CenterContainer/youwin.is_visible():
		handle_death()


func _on_deathpit_fall_detected(from, to):
	character.remove_child(camera)
	add_child(camera)
	camera.position = character.position
	


func _on_restart_pressed():
	Global.reset_score()
	main_gui.hide_leaderboard()
	get_tree().change_scene("res://level1.tscn")
	

func _on_mainchar_death():
	if not $CanvasLayer/CenterContainer/youwin.is_visible():
		handle_death()
	character.remove_child(camera)
	add_child(camera)
	camera.position = character.position
	
	
func handle_death():
	$CanvasLayer/CenterContainer/gameover.show()
	
	Global.num_lives -= 1
	if Global.num_lives == 0:
		Global.new_score()
	
	main_gui.update_ui()
	main_gui.show_leaderboard()
	

func _on_enemy_death(enemy, character):
	Global.score += enemy.score
	main_gui.update_ui()


func _on_youwin_completed():
	get_tree().change_scene(next_level)

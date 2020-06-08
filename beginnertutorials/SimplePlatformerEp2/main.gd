extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var camera = $mainchar/Camera2D
onready var character = $mainchar


func _on_goal_body_entered(body):
	$CanvasLayer/CenterContainer/youwin.show()



func _on_deathpit_death_detected(from, to):
	to.queue_free()
	$CanvasLayer/CenterContainer/gameover.show()


func _on_deathpit_fall_detected(from, to):
	character.remove_child(camera)
	add_child(camera)
	camera.position = character.position
	


func _on_restart_pressed():
	get_tree().change_scene("res://main.tscn")


func _on_mainchar_death():
	$CanvasLayer/CenterContainer/gameover.show()
	character.remove_child(camera)
	add_child(camera)
	camera.position = character.position

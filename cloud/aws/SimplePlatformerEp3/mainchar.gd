extends KinematicBody2D

class_name MainCharacter

signal death

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var gravity := 20000
export var max_jump := 80000
export var speed := 40000

onready var sprite := $mainchar

var curr_jump := max_jump
var on_the_ground := false
var jumping := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func receive_damage(damage):
	queue_free()
	emit_signal("death")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity:Vector2 = Vector2(0,1)*delta*gravity
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed*delta
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed*delta
		sprite.flip_h = true
	if Input.is_action_pressed("ui_up") and (on_the_ground or jumping):
		jumping = true
		velocity.y -= curr_jump*delta
		curr_jump /= 1.05
	if Input.is_action_just_released("ui_up"):
		jumping = false
		curr_jump = max_jump
		
	move_and_slide(velocity)
		
	

func _on_Area2D_body_entered(body):
	on_the_ground = true


func _on_Area2D_body_exited(body):
	on_the_ground = false

extends Node2D

export(float) var speed = 100
export(float) var arm_speed = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position.x = position.x + 10
	print(position)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x = position.x + speed*delta
	$arm_pivot.rotate(delta*arm_speed)

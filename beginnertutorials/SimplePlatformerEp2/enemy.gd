extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var attack := 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area2D_area_entered(area):
	print(area)
	queue_free()


func _on_RigidBody2D_body_entered(body):
	print(body)
	if body is MainCharacter:
		body.receive_damage(attack)


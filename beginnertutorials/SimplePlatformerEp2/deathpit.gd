extends Node2D

signal fall_detected(from, to)
signal death_detected(from, to)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_CameraSplit_area_entered(area):
	emit_signal("fall_detected", self, area)


func _on_CameraSplit_body_entered(body):
	emit_signal("fall_detected", self, body)


func _on_Area2DDeath2_area_entered(area):
	emit_signal("death_detected", self, area)


func _on_Area2DDeath2_body_entered(body):
	emit_signal("death_detected", self, body)

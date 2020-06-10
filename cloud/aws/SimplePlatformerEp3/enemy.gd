extends RigidBody2D

signal death(enemy, character)

export var attack := 1
export var score := 100

onready var timer := $Timer
onready var sprite := $enemy

var direction := 2.5
var duration := 3


# Called when the node enters the scene tree for the first time.
func _ready():
	timer.start(duration)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _integrate_forces(state: Physics2DDirectBodyState):
	state.transform = state.transform.translated(Vector2(direction,0))



func _on_Area2D_area_entered(area):
	emit_signal("death", self, area.get_parent())
	queue_free()


func _on_RigidBody2D_body_entered(body):
	if body is MainCharacter:
		body.receive_damage(attack)
	
	if body.name == "TileMapLevel":
		direction *= -1
		sprite.flip_h = !sprite.flip_h
		timer.start(duration)


func _on_Timer_timeout():
	direction *= -1
	sprite.flip_h = !sprite.flip_h
	timer.start(duration)

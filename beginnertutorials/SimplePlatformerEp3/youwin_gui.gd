extends VBoxContainer

signal completed

onready var time_label := $HBoxContainer/labeltimer
onready var tween := $Tween

var time := 5 setget _set_time


func _set_time(value):
	time = value
	time_label.text = String(time)
	
	
func trigger():
	tween.interpolate_property(self, "time", time, 0, time)
	tween.start()


func _on_Tween_tween_completed(object, key):
	emit_signal("completed")

extends Control

export(PoolVector2Array) var values := PoolVector2Array() setget _set_values
export(Color) var color := Color.white setget _set_color
export(float) var size := 20 setget _set_size
export(String, "circle", "rect") var shape := "circle" setget _set_shape
export(bool) var animate := true

onready var tween := $Tween

onready var drawn_values := values
onready var temp_drawn_values := values

func _set_values(value):
	values = value
	if tween != null:
		tween.interpolate_method(self, "configure_drawn_values", 0, 1, 2)
		tween.start()
	
func configure_drawn_values(range_id):
	for i in range(values.size()):
		drawn_values[i] = lerp(temp_drawn_values[i], values[i], range_id)
	if range_id == 1:
		temp_drawn_values = drawn_values
	update()
	
func _set_color(value):
	if tween != null and tween.is_active() or not animate:
		color = value
		update()
	else:
		tween.interpolate_property(self, "color", color, value, 2)
		tween.start()
func _set_size(value):
	if tween != null and tween.is_active() or not animate:
		size = value
		update()
	else:
		tween.interpolate_property(self, "size", size, value, 10)
		tween.start()
func _set_shape(value):
	shape = value
	update()

# Called when the node enters the scene tree for the first time.
func _ready():
	var a = values
	a[0].x = -1
	_set_values(a)
	pass # Replace with function body.

func _draw():
	var scale = get_size()
	var max_x = drawn_values[0].x
	var max_y = drawn_values[0].y
	var min_x = drawn_values[0].x
	var min_y = drawn_values[0].y
	for val in drawn_values:
		max_x = max(max_x, val.x)
		max_y = max(max_y, val.y)
		min_x = min(min_x, val.x)
		min_y = min(min_y, val.y)
		
		
	for val in drawn_values:
		var x = range_lerp(val.x, min_x, max_x, 0, scale.x)
		var y = range_lerp(val.y, min_y, max_y, 0, scale.y)*-1+get_size().y
		match shape:
			"circle": draw_circle(Vector2(x,y), size, color)
			"rect": draw_rect(Rect2(Vector2(x,y)-Vector2(size, size), 2*Vector2(size, size)), color)



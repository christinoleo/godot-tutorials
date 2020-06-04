extends PopupDialog


export(NodePath) var graph_edit


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

onready var title = $MarginContainer/VBoxContainer/HBoxContainer/TextEdit
onready var color_frame = $MarginContainer/VBoxContainer/HBoxContainer2/ColorFrame
onready var color_selected = $MarginContainer/VBoxContainer/HBoxContainer3/ColorSelected
var active_node : GraphNode

func activate(node):
	active_node = node
	title.text = node.title
	color_frame.color = node.get("custom_styles/frame").get_border_color()
	color_selected.color = node.get("custom_styles/selectedframe").get_border_color()
	popup_centered()


func _on_Save_pressed():
	get_node(graph_edit).save()
	hide()


func _on_ColorSelected_color_changed(color):
	active_node.set_border_color_rgb(color_frame.color, color_selected.color)


func _on_ColorFrame_color_changed(color):
	active_node.set_border_color_rgb(color_frame.color, color_selected.color)


func _on_TextEdit_text_changed(new_text):
	active_node.set_title(title.text)

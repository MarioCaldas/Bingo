extends Node2D

var value
var cellPostion = Vector2()
var isMarked = false

func setValueText(_value: int):
	value = _value
	get_node("RichTextLabel").bbcode_text = "[center]" + str(value)
	
func updateTextColor():
	get_node("RichTextLabel").set("custom_colors/default_color", Color(1,0,0,1))

	

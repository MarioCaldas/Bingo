extends Node2D

var value
var neighbours = Array()
var cellPostion = Vector2()

func setValueText(_value: int):
	value = _value
	get_node("RichTextLabel").bbcode_text = "[center]" + str(value)
	
func updateTextColor():
	get_node("RichTextLabel").set("custom_colors/default_color", Color(1,0,0,1))

func addNeighbour(_neighbour: Node2D):
	neighbours.append(_neighbour)
	

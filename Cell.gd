extends Node2D

var value

var neighbours = Array()

var cellPostion = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func updateTextValue(_value: int):
	value = _value
	get_node("RichTextLabel").add_text(str(value))
	
func updateTextColor():
	get_node("RichTextLabel").set("custom_colors/default_color", Color(1,0,0,1))

func addNeighbour(_neighbour: Node2D):
	neighbours.append(_neighbour)
	

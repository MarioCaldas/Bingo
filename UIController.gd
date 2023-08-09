extends Node2D

var playBtt

# Called when the node enters the scene tree for the first time.
func _ready():
	playBtt = get_node("Button")
	playBtt.get_node("RichTextLabel").text = "Start"
	Signals.connect("sUpdateTotalBallsText", self, "updateTotalBallsText")
	Signals.connect("sRoundFinished", self, "resetUI")
	
func _on_Button_pressed():
	Signals.emit_signal("sButtonPressed")
	if(playBtt.get_node("RichTextLabel").text == "Start"):
		playBtt.get_node("RichTextLabel").text = "Stop"
	else:
		playBtt.get_node("RichTextLabel").text = "Start"

func updateTotalBallsText(value):
	get_node("TotalBallsValue").text = str(value)
		
func resetUI():
	playBtt.get_node("RichTextLabel").text = "Start"

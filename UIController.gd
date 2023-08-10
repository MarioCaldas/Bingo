extends Node2D

var playBtt

# Called when the node enters the scene tree for the first time.
func _ready():
	playBtt = get_node("Button")
	playBtt.get_node("RichTextLabel").text = "Start"
	Signals.connect("sUpdateTotalBallsText", self, "updateTotalBallsText")
	Signals.connect("sRoundFinished", self, "resetPlayBtt")
	Signals.connect("sBingo", self, "showBingoLabel")
	Signals.connect("sReset", self, "resetUI")
	Signals.connect("sLinePrize", self, "showLinePrizes")
		
func _on_Button_pressed():
	Signals.emit_signal("sButtonPressed")
	if(playBtt.get_node("RichTextLabel").text == "Start"):
		playBtt.get_node("RichTextLabel").text = "Stop"
	else:
		playBtt.get_node("RichTextLabel").text = "Start"

func updateTotalBallsText(value):
	get_node("TotalBallsValue").text = str(value)
		
func showBingoLabel():
	get_node("WinBingoLabel").visible = true
	resetPlayBtt()

func resetPlayBtt():
	playBtt.get_node("RichTextLabel").text = "Start"

func resetUI():
	get_node("WinBingoLabel").visible = false
	resetLinePrizes()
	
func showLinePrizes(value):
	if(value == 0):
		get_node("Prizes").get_node("HorLinePrize").modulate = Color(1, 1, 1, 1)
	elif(value == 1):
		get_node("Prizes").get_node("VerLinePrize").modulate = Color(1, 1, 1, 1)
	elif(value == 2):
		get_node("Prizes").get_node("CornersPrize").modulate = Color(1, 1, 1, 1)
	elif(value == 3):
		get_node("Prizes").get_node("VLinePrize").modulate = Color(1, 1, 1, 1)
	elif(value == 4):
		get_node("Prizes").get_node("InvertedVLinePrize").modulate = Color(1, 1, 1, 1)

func resetLinePrizes():
	get_node("Prizes").get_node("HorLinePrize").modulate = Color(1, 1, 1, 0.3)
	get_node("Prizes").get_node("VerLinePrize").modulate = Color(1, 1, 1, 0.3)
	get_node("Prizes").get_node("CornersPrize").modulate = Color(1, 1, 1, 0.3)
	get_node("Prizes").get_node("VLinePrize").modulate = Color(1, 1, 1, 0.3)
	get_node("Prizes").get_node("InvertedVLinePrize").modulate = Color(1, 1, 1, 0.3)

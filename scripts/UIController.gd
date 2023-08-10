extends Node2D

var playBtt

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

func updateTotalBallsText(_value):
	get_node("TotalBallsValue").text = str(_value)
		
func showBingoLabel():
	get_node("WinBingoLabel").visible = true
	resetPlayBtt()

func resetPlayBtt():
	playBtt.get_node("RichTextLabel").text = "Start"

func resetUI():
	get_node("WinBingoLabel").visible = false
	resetLinePrizes()
	
func showLinePrizes(_value):
	var alphaValue = 1
	if(_value == 0):
		get_node("PrizesImages").get_node("HorLinePrize").modulate = Color(1, 1, 1, alphaValue)
	elif(_value == 1):
		get_node("PrizesImages").get_node("VerLinePrize").modulate = Color(1, 1, 1, alphaValue)
	elif(_value == 2):
		get_node("PrizesImages").get_node("CornersPrize").modulate = Color(1, 1, 1, alphaValue)
	elif(_value == 3):
		get_node("PrizesImages").get_node("VLinePrize").modulate = Color(1, 1, 1, alphaValue)
	elif(_value == 4):
		get_node("PrizesImages").get_node("InvertedVLinePrize").modulate = Color(1, 1, 1, alphaValue)

func resetLinePrizes():
	var alphaValue = 0.3
	get_node("PrizesImages").get_node("HorLinePrize").modulate = Color(1, 1, 1, alphaValue)
	get_node("PrizesImages").get_node("VerLinePrize").modulate = Color(1, 1, 1, alphaValue)
	get_node("PrizesImages").get_node("CornersPrize").modulate = Color(1, 1, 1, alphaValue)
	get_node("PrizesImages").get_node("VLinePrize").modulate = Color(1, 1, 1, alphaValue)
	get_node("PrizesImages").get_node("InvertedVLinePrize").modulate = Color(1, 1, 1, alphaValue)

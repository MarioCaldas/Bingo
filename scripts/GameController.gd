extends Node2D

var gameStoped = false

var roundFinished = false

func _ready():
	stopAndResumeGame()
	Signals.emit_signal("sGenerateGrid")	
	Signals.connect("sButtonPressed", self, "stopAndResumeGame")
	Signals.connect("sRoundFinished", self, "roundFinished")
	Signals.connect("sBingo", self, "stopAndResumeGame")

func stopAndResumeGame():
	if(roundFinished):
		resetGame()
	else:
		if(!gameStoped):
			get_tree().paused = true
			gameStoped = true
		else:
			get_tree().paused = false
			gameStoped = false

func roundFinished():
	roundFinished = true

func resetGame():
	Signals.emit_signal("sReset")
	roundFinished = false
	gameStoped = false
	get_tree().paused = gameStoped

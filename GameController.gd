extends Node2D

var gameStoped = false

var roundFinished

# Called when the node enters the scene tree for the first time.
func _ready():
	stopAndResumeGame()
	Signals.connect("sButtonPressed", self, "stopAndResumeGame")
	Signals.emit_signal("sGenerateGrid")
	Signals.emit_signal("sGenerateBall")
	Signals.connect("sRoundFinished", self, "roundFinished")
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

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
	

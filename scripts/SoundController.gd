extends Node2D

const sound1 = preload("res://sounds/fail.mp3")
const sound2 = preload("res://sounds/success.mp3")

func _ready():
	Signals.connect("sPlaySuccessSound", self, "playSuccessSound")
	Signals.connect("sPlayFailSound", self, "playFailSound")
	
func playSuccessSound():
	get_node("AudioStreamPlayer2D").stream = sound2
	get_node("AudioStreamPlayer2D").play()

	
func playFailSound():
	get_node("AudioStreamPlayer2D").stream = sound1
	get_node("AudioStreamPlayer2D").play()


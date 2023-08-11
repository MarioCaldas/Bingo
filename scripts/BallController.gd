extends Node2D

var randomizer = RandomNumberGenerator.new()

var ballsNumbers = Array()
var ballsInstantiated = Array()
var ballsColors = Dictionary()

const ball = preload("res://Ball.tscn")

const maxQueueBalls = 4

export var minBallValue = 1
export var maxBallValue = 60

var totalRoundBallsAmount = 30
var curRoundBallsAmount = 0

var ballQueueTimout = 2

func _ready():
	Signals.connect("sGenerateBall", self, "generateBall")
	Signals.connect("sReset", self, "resetBalls")
	randomizer.randomize()
	setBallsColors()
	if(totalRoundBallsAmount > maxBallValue):
		totalRoundBallsAmount = maxBallValue
	
	Signals.emit_signal("sUpdateTotalBallsText", totalRoundBallsAmount)

func generateBall():
	if(ballsInstantiated.size() < maxQueueBalls && curRoundBallsAmount < totalRoundBallsAmount):
		var randomNumber = randomizer.randi_range(minBallValue, maxBallValue)
		if !ballsNumbers.has(randomNumber):
			ballsNumbers.append(randomNumber)
			instantiateBall(randomNumber)
		else:
			generateBall()
	elif(curRoundBallsAmount >= totalRoundBallsAmount):
		get_node("Timer").stop()
		
	Signals.emit_signal("sUpdateTotalBallsText", totalRoundBallsAmount - curRoundBallsAmount)

func instantiateBall(_value: int): 
	var newBall = ball.instance()
	newBall.visible = false
	newBall.setValueText(_value)
	add_child(newBall)
	ballsInstantiated.append(newBall)
	var groupColor = (_value - 1) / 10 + 1
	newBall.get_node("texture").modulate = ballsColors[groupColor]
	newBall.setPoint2OnQueue(ballsInstantiated.size() - 1)
	curRoundBallsAmount += 1	

func updateQueue():
	var currentBall = ballsInstantiated.pop_front()
	currentBall.queue_free()
	for i in ballsInstantiated.size():
		if(ballsInstantiated[i] != null):
			ballsInstantiated[i].moveDuration = ballsInstantiated[ballsInstantiated.size() - 1].moveDuration
			ballsInstantiated[i].resumeMovement()
			
	if(ballsInstantiated.size() <= 0):
		Signals.emit_signal("sRoundFinished")
				

func _on_Timer_timeout():
	Signals.emit_signal("sGenerateBall")


func setBallsColors():
	ballsColors = {
		1 : Color.red,
		2 : Color.blue,
		3 : Color.green,
		4 : Color.purple,
		5 : Color.yellow,
		6 : Color.orange,
		7 : Color.pink,
		8 : Color.brown,
		9 : Color.gray
	}


func resetBalls():
	ballsNumbers.clear()
	for i in ballsInstantiated.size():
		ballsInstantiated[i].queue_free()
	ballsInstantiated.clear()
	curRoundBallsAmount = 0
	get_node("Timer").start()
	

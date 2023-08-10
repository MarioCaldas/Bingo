extends Node2D

var randomizer = RandomNumberGenerator.new()

var ballsNumbers = Array()
var ballsObj = Array()
var ballsColors = Dictionary()

const ball = preload("res://Ball.tscn")

const maxQueueBalls = 4

export var minBallValue = 1
export var maxBallValue = 60

var totalRoundBallsAmount = 40
var curRoundBallsAmount = 0

var ballQueueTimout = 2

func _ready():
	Signals.connect("sGenerateBall", self, "generateBall")
	Signals.connect("sReset", self, "resetBalls")
	randomizer.randomize()
	setBallsColors()
	if(totalRoundBallsAmount > maxBallValue):
		totalRoundBallsAmount = maxBallValue


func generateBall():
	if(ballsObj.size() < maxQueueBalls):
		var randomNumber = randomizer.randi_range(minBallValue, maxBallValue)
		if !ballsNumbers.has(randomNumber):
			ballsNumbers.append(randomNumber)
			instantiateBall(randomNumber)
			curRoundBallsAmount += 1
			Signals.emit_signal("sUpdateTotalBallsText", totalRoundBallsAmount - curRoundBallsAmount)
		else:
			generateBall()
	elif(curRoundBallsAmount >= totalRoundBallsAmount):
		get_node("Timer").stop()


func instantiateBall(_value: int): 
	var newBall = ball.instance()
	newBall.visible = false
	newBall.setValueText(_value)
	add_child(newBall)
	ballsObj.append(newBall)
	var groupColor = (_value - 1) / 10 + 1
	newBall.get_node("BBall").modulate = ballsColors[groupColor]
	newBall.setPoint2OnQueue(ballsObj.size() - 1)
		

func updateQueue():
	var currentBall = ballsObj.pop_front()
	currentBall.queue_free()
	for i in range(ballsObj.size()):
		if(ballsObj[i] != null):
			ballsObj[i].moveDuration = ballsObj[ballsObj.size() - 1].moveDuration
			ballsObj[i].resumeMovement()
			
	if(ballsObj.size() <= 0):
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
	for i in ballsObj.size():
		ballsObj[i].queue_free()
	ballsObj.clear()
	curRoundBallsAmount = 0
	get_node("Timer").start()
	

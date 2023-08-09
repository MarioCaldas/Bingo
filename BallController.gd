extends Node2D

var randomizer = RandomNumberGenerator.new()

var ballsNumbers = Array()
var ballsObj = Array()#optimizar
var ballsColors = {}

const ball = preload("res://Ball.tscn")
	
var timer2

const maxQueueCurrentBalls = 4

const minBallValue = 1
const maxBallValue = 30

const totalRoundBallsAmount = 300
var curRoundBallsAmount = 0

func _ready():
	Signals.connect("sGenerateBall", self, "generateBall")
	Signals.connect("sReset", self, "resetBalls")
	randomizer.randomize()
	timer2 = get_node("Timer2")
	timer2.start()
	setBallsColors()

var teste = 0
func generateBall():
	if(ballsObj.size() < maxQueueCurrentBalls):
		var randomNumber = randomizer.randi_range(minBallValue, maxBallValue)
		if !ballsNumbers.has(randomNumber):
			ballsNumbers.append(randomNumber)
			#print("Generated unique number:", randomNumber)
			instantiateBall(randomNumber)
			Signals.emit_signal("sUpdateTotalBallsText", totalRoundBallsAmount - curRoundBallsAmount)
			curRoundBallsAmount += 1
		else:
			generateBall()
	elif(curRoundBallsAmount >= totalRoundBallsAmount):
		get_node("Timer").stop()
		Signals.emit_signal("sUpdateTotalBallsText", totalRoundBallsAmount - curRoundBallsAmount)

func instantiateBall(value: int): 
	var newBall = ball.instance()
	newBall.visible = false
	newBall.setValueText(value)
	add_child(newBall)
	ballsObj.append(newBall)
	var groupColor = (value - 1) / 10 + 1
	newBall.get_node("BBall").modulate = ballsColors[groupColor]
	newBall.setPoint2OnQueue(ballsObj.size() - 1)
		

func updateQueue():
	var currentBall = ballsObj.pop_front()
	currentBall.queue_free()
	for i in range(ballsObj.size()):
		if(ballsObj[i] != null):
			ballsObj[i].resumeMovement()
			
	if(ballsObj.size() <= 0):
		get_node("Timer2").stop()
		Signals.emit_signal("sRoundFinished")
				
func _on_Timer_timeout():
	Signals.emit_signal("sGenerateBall")

func _on_Timer2_timeout():
	updateQueue()


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

func startTimers():
	get_node("Timer").start()
	get_node("Timer2").start()

func resetBalls():
	ballsNumbers.clear()
	for i in ballsObj.size():
		ballsObj[i].queue_free()
	ballsObj.clear()
	curRoundBallsAmount = 0
	startTimers()
	

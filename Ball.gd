extends Node2D

var point1 = Vector2(0,0)
var point2 = Vector2(0,0)
# Define basic variables and settings
var time = 0
var moveDuration = 2
var progress = 0
var isFinished = false

var value

var positionInQueue
var screenSize

var updateDist
var initDist

func _ready():
	screenSize = get_viewport().get_visible_rect().size
	point1 = Vector2(screenSize.x - (screenSize.x * 0.28), screenSize.y * 0.2)
	point2 = Vector2(screenSize.x * 0.28, screenSize.y * 0.2)
	positionInQueue = 0
	scale = Vector2(0.7, 0.7)
	initDist = point1.distance_to(point2)



func _process(delta):
	visible = true
	time += delta
	if(progress < 1):
		progress = time / moveDuration
		position = lerp(point1,point2, progress)
	elif(!isFinished):
		if(positionInQueue == 0):
			Signals.emit_signal("sPathCompleted", value)
		isFinished = true


func recalculateMoveDuration() -> int:
	return (updateDist * moveDuration) / initDist


func setPoint2OnQueue(pos: int):
	positionInQueue = pos
	point2 = Vector2(point2.x + (positionInQueue * 105), point2.y)
	updateDist = point1.distance_to(point2)
	moveDuration = recalculateMoveDuration()

	
func resumeMovement():
	time = 0
	isFinished = false
	point1 = position
	positionInQueue -= 1
	point2 = Vector2((screenSize.x * 0.28) + (positionInQueue * 105), screenSize.y * 0.2)
	progress = 0


func setValueText(_value: int):
	value = _value
	get_node("RichTextLabel").add_text(str(value))

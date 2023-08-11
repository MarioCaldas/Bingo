extends Node2D

export var width = 5
export var height = 3
export var minGridNumberValue = 1
export var maxGridNumberValue = 60
const marginX = 32
const marginY = 28

var gridValues = Dictionary()
var gridPositions = Dictionary()
var linePrizes = Dictionary()

const cell = preload("res://Cell.tscn")
const cell_size = 10

var randomizer = RandomNumberGenerator.new()

var totalMarkedCells = 0

enum PrizeType {
	HORIZONTAL,
	VERTICAL,
	CORNERS,
	V,
	INVERTED_V
}

func _ready():
	Signals.connect("sGenerateGrid", self, "generateGrid")
	Signals.connect("sPathCompleted", self, "checkValue")
	Signals.connect("sReset", self, "resetGrid")

	
func generateGrid():
	for x in width:
		for y in height:
			var cell_instance = instantiateCell()
			cell_instance.cellPostion = Vector2(x,y)
			var gridOffset = Vector2(marginX, marginY)
			var cellOffset = Vector2(x, y) * (cell_size) + gridOffset
			cell_instance.position = gridToWorld(cellOffset)			
			var value = generateRandomUniqueNumbers()	
			cell_instance.setValueText(value)	
			gridValues[value] = cell_instance
			gridPositions[Vector2(x,y)] = gridValues[value]


func findPrizes(cellPoss: Vector2):
	if !gridPositions.has(cellPoss):
		return
	
	var countUp = 1
	var countDown = 1
	var countRight = 1
	var countLeft = 1
	
	#Check Vertical prize
	if !linePrizes.has(PrizeType.VERTICAL):
		while checkCellMarked(Vector2(cellPoss.x, cellPoss.y + countUp)):
			countUp += 1
	
		while checkCellMarked(Vector2(cellPoss.x, cellPoss.y - countDown)):
			countDown += 1
			
	#Check Horizontal prize
	if !linePrizes.has(PrizeType.HORIZONTAL):
		while checkCellMarked(Vector2(cellPoss.x + countRight, cellPoss.y)):
			countRight += 1
		
		while checkCellMarked(Vector2(cellPoss.x - countLeft, cellPoss.y)):
			countLeft += 1
	
	if countUp + countDown - 1 == height:
		Signals.emit_signal("sLinePrize", PrizeType.VERTICAL)
		linePrizes[PrizeType.VERTICAL] = true	
	
	if countRight + countLeft - 1 == width:
		Signals.emit_signal("sLinePrize", PrizeType.HORIZONTAL)
		linePrizes[PrizeType.HORIZONTAL] = true	
		
	# Check for corners prize
	if !linePrizes.has(PrizeType.CORNERS):	
		var corners = [Vector2(0, 0), Vector2(0, height - 1), Vector2(width - 1, 0), Vector2(width - 1, height - 1)]
		var allCornersMarked = true

		for corner in corners:
			if !gridPositions[corner].isMarked:
				allCornersMarked = false
				break
		if allCornersMarked:
			Signals.emit_signal("sLinePrize", PrizeType.CORNERS)
			linePrizes[PrizeType.CORNERS] = true
		

	# check for V and Inverted V prize and bingo
	if !linePrizes.has(PrizeType.V) || !linePrizes.has(PrizeType.INVERTED_V):	
		for x in width:
			for y in height:
				if checkCellMarked(Vector2(x,y)) && checkCellMarked(Vector2(x - 1,y - 1)) && checkCellMarked(Vector2(x + 1,y - 1)):
					linePrizes[PrizeType.V] = true
					Signals.emit_signal("sLinePrize", PrizeType.V)
				if checkCellMarked(Vector2(x,y)) && checkCellMarked(Vector2(x - 1,y + 1)) && checkCellMarked(Vector2(x + 1,y + 1)):
					linePrizes[PrizeType.INVERTED_V] = true	
					Signals.emit_signal("sLinePrize", PrizeType.INVERTED_V)
					
	
	totalMarkedCells += 1

	if totalMarkedCells == (width * height):
		Signals.emit_signal("sBingo")
		Signals.emit_signal("sRoundFinished")
	
	
func checkCellMarked(pos: Vector2) -> bool:
	return gridPositions.has(pos) && gridPositions[pos].isMarked


func gridToWorld(_pos: Vector2) -> Vector2:
	return _pos * cell_size
	
func instantiateCell() -> Node2D:  
	var newCell = cell.instance()
	add_child(newCell)
	return newCell

func generateRandomUniqueNumbers() -> int:
	randomizer.randomize() 
	var randomNumber = randomizer.randi_range(minGridNumberValue, maxGridNumberValue)		
	while gridValues.has(randomNumber):
		randomNumber = randomizer.randi_range(minGridNumberValue, maxGridNumberValue)
	return randomNumber
	

func checkValue(_value : int):
	if gridValues.has(_value):
		gridValues[_value].isMarked = true
		findPrizes(gridValues[_value].cellPostion)
		gridValues[_value].updateTextColor()
		Signals.emit_signal("sPlaySuccessSound")
	else:
		Signals.emit_signal("sPlayFailSound")


func resetGrid():
	for i in gridValues.keys():
		gridValues[i].queue_free()
	gridValues.clear()
	linePrizes.clear()
	gridPositions.clear()
	generateGrid()
	totalMarkedCells = 0



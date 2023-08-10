extends Node2D

export var width = 5
export var height = 3
export var minGridNumberValue = 1
export var maxGridNumberValue = 60
const cell_size = 10
const marginX = 32
const marginY = 28

var grid = Dictionary()
var linePrizes = Dictionary()
var markedCells = Array()

enum PrizeType {
	HORIZONTAL,
	VERTICAL,
	CORNERS,
	V,
	INVERTED_V
}

const cell = preload("res://Cell.tscn")

var randomizer = RandomNumberGenerator.new()

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
			grid[value] = cell_instance


func gridToWorld(_pos: Vector2) -> Vector2:
	return _pos * cell_size
	
func instantiateCell() -> Node2D:  
	var newCell = cell.instance()
	add_child(newCell)
	return newCell

func generateRandomUniqueNumbers() -> int:
	randomizer.randomize() 
	var randomNumber = randomizer.randi_range(minGridNumberValue, maxGridNumberValue)		
	while grid.has(randomNumber):
		randomNumber = randomizer.randi_range(minGridNumberValue, maxGridNumberValue)
	return randomNumber
	

func checkValue(_value : int):
	if grid.has(_value):
		markCell(grid[_value].cellPostion)
		grid[_value].updateTextColor()
		Signals.emit_signal("sPlaySuccessSound")
	else:
		Signals.emit_signal("sPlayFailSound")


func markCell(_cell_position: Vector2):
	if not isVector2InArray(_cell_position, markedCells):
		markedCells.append(_cell_position)
		checkPrizes()
		

func isVector2InArray(_vector: Vector2, _array: Array) -> bool:
	for item in _array:
		if item == _vector:
			return true
	return false
	

func checkPrizes():
	# Check for horizontal prize
	if !linePrizes.has(PrizeType.HORIZONTAL):
		for y in range(height):
			var line = []
			for x in range(width):
				if Vector2(x, y) in markedCells:
					line.append(Vector2(x, y))

			if len(line) == width:
				Signals.emit_signal("sLinePrize", PrizeType.HORIZONTAL)
				linePrizes[PrizeType.HORIZONTAL] = true
				break

	# Check for vertical prize
	if !linePrizes.has(PrizeType.VERTICAL):	
		for x in range(width):
			var line = []
			for y in range(height):
				if Vector2(x, y) in markedCells:
					line.append(Vector2(x, y))
			if len(line) == height:
				Signals.emit_signal("sLinePrize", PrizeType.VERTICAL)
				linePrizes[PrizeType.VERTICAL] = true
				break

	# Check for corners prize
	if !linePrizes.has(PrizeType.CORNERS):	
		var corners = [Vector2(0, 0), Vector2(0, height - 1), Vector2(width - 1, 0), Vector2(width - 1, height - 1)]
		var allCornersMarked = true
		for corner in corners:
			if !(corner in markedCells):
				allCornersMarked = false
				break
		if allCornersMarked:
			Signals.emit_signal("sLinePrize", PrizeType.CORNERS)
			linePrizes[PrizeType.CORNERS] = true
			
	# check for V and Inverted V prize
	if !linePrizes.has(PrizeType.V) || !linePrizes.has(PrizeType.INVERTED_V):	
		for x in range(width):
			for y in range(height):
				if Vector2(x,y) in markedCells && Vector2(x - 1,y - 1) in markedCells && Vector2(x + 1,y - 1) in markedCells:
					linePrizes[PrizeType.V] = true
					Signals.emit_signal("sLinePrize", PrizeType.V)
				if Vector2(x,y) in markedCells && Vector2(x - 1,y + 1) in markedCells && Vector2(x + 1,y + 1) in markedCells:
					linePrizes[PrizeType.INVERTED_V] = true	
					Signals.emit_signal("sLinePrize", PrizeType.INVERTED_V)
				

	# Check for bingo
	if markedCells.size() == (width * height):
		Signals.emit_signal("sBingo")
		Signals.emit_signal("sRoundFinished")


func resetGrid():
	for i in grid.keys():
		grid[i].queue_free()
	grid.clear()
	markedCells.clear()
	linePrizes.clear()
	generateGrid()



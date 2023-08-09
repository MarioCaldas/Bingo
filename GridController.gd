extends Node2D

export var width : int = 5
export var height : int = 3
export var cell_size : int = 10
var marginX : int = 32
var marginY : int = 28

var grid: Dictionary = {}
var gridNumbers = Array()

const cell = preload("res://Cell.tscn")

var randomizer = RandomNumberGenerator.new()

func _ready():
	Signals.connect("sGenerateGrid", self, "generateGrid")
	Signals.connect("sPathCompleted", self, "checkPrizes")
	Signals.connect("sReset", self, "resetGrid")
	
	
func generateGrid():
	var cellCount: int = 0
	for x in width:
		for y in height:
			#grid[Vector2(x,y)] = null

			var cell_instance = _instantiateCell()
			cell_instance.cellPostion = Vector2(x,y)
			
			var gridOffset = Vector2(marginX, marginY)

			var cellOffset = Vector2(x, y) * (cell_size) + gridOffset

			cell_instance.position = gridToWorld(cellOffset)
			
			var value = generateRandomUniqueNumbers()	

			cell_instance.updateTextValue(value)
			cellCount += 1
			
			grid[value] = cell_instance
			
			gridNumbers.append(value)
				
	#print(grid)
	#setCellsNeighbours()
	#debugNeig()

func setCellsNeighbours():
	for x in width:
		for y in height:
			setNeighboursForCell(x, y)

func setNeighboursForCell(row: int, col: int):
	var MIN_ROW = -1
	var MAX_ROW = 1
	var MIN_COL = -1
	var MAX_COL = 1


	var currentCell = grid[Vector2(row,col)]

	for neighborRow in range(row + MIN_ROW, row + MAX_ROW + 1):
		for neighborCol in range(col + MIN_COL, col + MAX_COL + 1):
			if neighborRow == row and neighborCol == col:
				continue

			if isValidCell(neighborRow, neighborCol):
				var neighborCell = grid[Vector2(neighborRow,neighborCol)]
				if neighborCell != null:
					currentCell.addNeighbour(neighborCell)

func debugNeig():
	for x in width :
		for y in height:
			print("grid[Vector2(x,y)]")
			print(grid[Vector2(x,y)].value)
			print("--")
			for f in grid[Vector2(x,y)].neighbours.size():
				print(grid[Vector2(x,y)].neighbours[f].value)
			print("--------------------")

func isValidCell(col: int, row: int) -> bool:
	return row >= 0 && row < height && col >= 0 && col < width
	

func gridToWorld(_pos: Vector2) -> Vector2:
	return _pos * cell_size
	

func _instantiateCell() -> Node2D:  
	var newCell = cell.instance()
	add_child(newCell)
	return newCell

func generateRandomUniqueNumbers() -> int:
	randomizer.randomize()  # Seed the random number generator

	var randomNumber = randomizer.randi_range(1, 30)
		
	while grid.has(randomNumber):
		randomNumber = randomizer.randi_range(1, 30)

	return randomNumber
	
	

func checkPrizes(_value : int):
	if grid.has(_value):
		markCell(grid[_value].cellPostion)
		grid[_value].updateTextColor()
		Signals.emit_signal("sPlaySuccessSound")
	else:
		Signals.emit_signal("sPlayFailSound")

# List to keep track of marked cells
var markedCells := []

# Call this function when a player marks a cell
func markCell(cell_position: Vector2):
	if not isVector2InArray(cell_position, markedCells):
		markedCells.append(cell_position)
		checkForWin()
		
		#debugmarkCell()

func debugmarkCell():
	for i in range(markedCells.size()):
		print("Element ", i, ": ", str(markedCells[i]))
	print("-----------------------")

func isVector2InArray(vector: Vector2, array: Array) -> bool:
	for item in array:
		if item == vector:
			return true
	return false
	
# Check for winning combinations
func checkForWin():
	var hasWon = false
	var boardSize = int(sqrt(grid.size()))
	print(markedCells)
	# Check for horizontal lines
	for y in range(height):
		var line = []
		for x in range(width):
			var cell_position = Vector2(x, y)
			if cell_position in markedCells:
				line.append(cell_position)

		if len(line) == width:
			get_node("HorLineBingo").visible = true
			print("HORIZONTAL")
			hasWon = true
			break

	# Check for vertical lines
	#if not hasWon:
	for x in range(width):
		var line = []
		for y in range(height):
			var cell_position = Vector2(x, y)
			if cell_position in markedCells:
				line.append(cell_position)
		if len(line) == height:
			get_node("VerLineBingo").visible = true
			print("Vertical")
			hasWon = true
			break

	# Check for corner wins
	#if not hasWon:
	var corners = [Vector2(0, 0), Vector2(0, height - 1), Vector2(width - 1, 0), Vector2(width - 1, height - 1)]
	var allCornersMarked = true
	for corner in corners:
		if !(corner in markedCells):
			allCornersMarked = false
			break
	if allCornersMarked:
		get_node("CornersBingo").visible = true
		hasWon = true


	if markedCells.size() == (width * height):
		hasWon = true

#	if hasWon:
#		print("Bingo! You have won!")
		
	# Check for diagonal lines (only if the board is square)
#	if not hasWon and boardSize == boardSize:
#		var line = []
#		for i in range(boardSize):
#			var cell_position = i * boardSize + i
#			if cell_position in markedCells:
#				line.append(cell_position)
#		if len(line) == boardSize:
#			hasWon = true
#
#		if not hasWon:
#			line.clear()
#			for i in range(boardSize):
#				var cell_position = (i * boardSize) + (boardSize - 1 - i)
#				if cell_position in markedCells:
#					line.append(cell_position)
#			if len(line) == boardSize:
#				hasWon = true

func resetGrid():
	gridNumbers.clear()
	for i in grid.keys():
		print(grid[i].value)
		grid[i].queue_free()
	grid.clear()
	generateGrid()


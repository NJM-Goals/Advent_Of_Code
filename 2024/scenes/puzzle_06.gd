
extends Node

# the map on which the guard moves
var map = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func print_lines(caption, lines):
	print(caption)
	for line in lines:
		print("  ", line)


func lines_to_arr(lines):
	var arr = []
	for line in lines:
		if line.length() == 0:
			continue

		for char in line:
			arr.push_back(char)

	return arr


func is_out(pos, cols, rows):
	if pos[0] < 0 or pos[0] >= cols:
		return true
	
	if pos[1] < 0 or pos[1] >= rows:
		return true
		
	return false


func find_item(lines, item):
	var y = 0
	var x = 0
	for line in lines:
		x = line.find(item)
		if x >= 0:
			return [x, y]
		y += 1


func get_item(lines, pos):
	var line = lines[pos[1]]
	var item = line.substr(pos[0], 1)
	return item


func is_obstacle(guard, guard_o):
	var in_front = ""
	if guard_o == "up":
		in_front = get_item(map, [guard[0], guard[1] - 1])
	elif guard_o == "down":
		in_front = get_item(map, [guard[0], guard[1] + 1])
	elif guard_o == "right":
		in_front = get_item(map, [guard[0] + 1, guard[1]])
	elif guard_o == "left":
		in_front = get_item(map, [guard[0] - 1, guard[1]])
	
	if in_front == '#':
		return true
	
	return false


func rotate(guard_o):
	if guard_o == "up":
		return "right"
	elif guard_o == "down":
		return "left"
	elif guard_o == "right":
		return "down"
	elif guard_o == "left":
		return "up"


func move(guard_o, guard):
	if guard_o == "up":
		guard[1] -= 1
	elif guard_o == "down":
		guard[1] += 1
	elif guard_o == "right":
		guard[0] += 1
	elif guard_o == "left":
		guard[0] -= 1
		
	return guard


func copy_lines(lines):
	var copy = []
	for line in lines:
		var new_line = String(line)
		copy.push_back(new_line)
	
	return copy

func mark(lines, pos):
	lines[pos[1]][pos[0]] = "X"


func count_chars(lines, char):
	var count = 0
	for line in lines:
		count += line.count(char)
	
	return count

func process_lines(lines):
	
	var cols = lines[0].length()
	print("cols: ", cols)
	var rows = lines.size() - 1  # subtract last empty line
	print("rows: ", rows)

	var arr = lines_to_arr(lines)
	var guard_start = find_item(lines, '^')
	print("guard_start: ", guard_start)
	
	var guard = guard_start
	var guard_o = "up"  # guard orientation
	map = lines
	var walk = copy_lines(lines)
	while !is_out(guard, cols, rows):
		mark(walk, guard)
		
		if is_obstacle(guard, guard_o):
			guard_o = rotate(guard_o)
		else:
			guard = move(guard_o, guard)
	
	print_lines("Walked map", walk)
	
	var marks = count_chars(walk, 'X')


	# Part 1 - Right answer: 4903
	print("Part 1 marks: ", marks)
	
	# Part 2 - Right answer: 
	print("Part 2 : ", )



func run_puzzle():
	print("Puzzle 06")
	
	var puzzles = []
	var a = "res://puzzle_input/puzzle_input_06.txt"
	var b = "res://puzzle_input/puzzle_input_06_example.txt"
	var paths = [b, a]
	#var paths = [b]
	
	for path in paths:
		var puzzle = FileAccess.open(path, FileAccess.READ)
		var content = puzzle.get_as_text()
	
		var lines = content.split('\n')
	
		process_lines(lines)
		
		#process_lines_part_2(lines)

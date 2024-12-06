
extends Node

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


func process_lines(lines):
	var lines_amount = lines.size() - 1  # subtract last empty line
	print("lines_amount: ", lines_amount)

	for line in lines:

		if line.length() == 0:
			continue

	# Part 1 - Right answer: 
	print("Part 1 : ", )
	
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

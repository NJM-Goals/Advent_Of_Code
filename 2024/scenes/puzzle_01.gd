extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var card_count = 0

func process_lines(lines):
	var sum = 0
	var loop_count = 0
	
	# contains all left numbers
	var lefts = []
	# contains all right numbers
	var rights = []

	# put all left and right numbers each into their arrays
	for line in lines:
		#print(line)
		
		if line.length() == 0:
			continue
		
		var line_arr = line.split("   ")
		var left = int(line_arr[0])
		var right = int(line_arr[1])
		
		#print("left: '", left, "'")
		#print("right: '", right, "'")
		
		lefts.append(left)
		rights.append(right)
	
	lefts.sort()
	rights.sort()
	#print("lefts: ", lefts)
	#print("rights: ", rights)
	
	var sum_of_diffs = 0
	var similarity_score = 0
	for i in range(0, lefts.size()):
		var diff = abs(rights[i] - lefts[i])
		print("diff: ", diff)
		sum_of_diffs += diff
		
		var left = lefts[i]
		
		# How often does the left number appear in the right numbers
		var amount = 0
		for right in rights:
			if left == right:
				amount += 1
		print("amount: ", amount)
		
		similarity_score += left * amount
	
	# Part 1 - Right answer: 1941353
	print("sum of diffs: ", sum_of_diffs)
	
	# Part 2 - Right answer: 22539317
	print("similarity_score: ", similarity_score)



func run_puzzle():
	print("Puzzle 01")
	
	var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_01.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_01_example.txt", FileAccess.READ)
	var content = puzzle.get_as_text()
	
	var lines = content.split('\n')
	
	process_lines(lines)

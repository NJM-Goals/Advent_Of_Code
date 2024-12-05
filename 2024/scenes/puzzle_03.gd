
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func extract_numbers(mul):
	var mul_removed = mul.substr(4, mul.length() - 3)
	#print("mul_removed: ", mul_removed)
	
	var numbers_as_str = mul_removed.split(",")
	
	var numbers = [int(numbers_as_str[0]), int(numbers_as_str[1])]
	
	#print("numbers: ", numbers)
	
	return numbers


func process_lines(lines):
	
	# Part 1 use a regex to find mul(x,y)
	var mul_regex = RegEx.new()
	mul_regex.compile(r'(mul\([0-9]*,[0-9]*\))')
	# regex with negative look behind to exclude do_not_mul <-- not needed, because it is not part of the task
	#mul_regex.compile(r'((?<!do_not_)mul\([0-9]*,[0-9]*\))')
	
	# Part 2 regex to find do(), don't() and mul(x,y)
	var part_2_regex = RegEx.new()
	part_2_regex.compile(r'(do\(\))|(don\'t\(\))|(mul\([0-9]*,[0-9]*\))')
	
	var sum_of_mul = 0

	var part_2_findings = []

	for line in lines:
		#print(line)
		
		if line.length() == 0:
			continue


		var matches = mul_regex.search_all(line)

		# Part 1
		for match in matches:
			var mul_str = match.get_string()
			#print("mul_str ", mul_str)
			
			# Extract the 2 numbers
			var numbers = extract_numbers(mul_str)
			
			var product = numbers[0] * numbers[1]
			
			sum_of_mul += product


		# Part 2
		var part_2_matches = part_2_regex.search_all(line)

		#print("part_2_matches: ")
		for match in part_2_matches:
			var str = match.get_string()
			part_2_findings.push_back(str)
			#print("  ", str)


	# Part 2 - evaluation of findings
	var sum_of_mul_2 = 0
	print("part_2_findings: ", part_2_findings)
	
	var is_do = true
	for item in part_2_findings:
		if is_do and item.begins_with("mul"):
			var numbers = extract_numbers(item)
			var product = numbers[0] * numbers[1]
			sum_of_mul_2 += product
		elif item.begins_with("do("):
			is_do = true
		elif item.begins_with("don"):
			is_do = false


	# Part 1 - Right answer: 159833790
	print("Part 1 sum_of_mul: ", sum_of_mul)

	# Part 2 - Right answer: 89349241
	print("Part 2 sum_of_mul_2: ", sum_of_mul_2)


func run_puzzle():
	print("Puzzle 03")
	
	var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03_example.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03_part_2_example.txt", FileAccess.READ)
	var content = puzzle.get_as_text()
	
	var lines = content.split('\n')
	
	process_lines(lines)


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
	
	# use a regex to find mul(x,y)
	var mul_regex = RegEx.new()
	mul_regex.compile(r'(mul\([0-9]*,[0-9]*\))')
	# regex with negative look behind to exclude do_not_mul <-- not needed, because it is not part of the task
	#mul_regex.compile(r'((?<!do_not_)mul\([0-9]*,[0-9]*\))')
	
	# Part 2 do regex
	var do_regex = RegEx.new()
	do_regex.compile(r'(do\(\))')
	
	# Part 2 don't regex
	var dont_regex = RegEx.new()
	dont_regex.compile(r'(don\'t\(\))')
	
	var sum_of_mul = 0

	var all_arr = []

	for line in lines:
		#print(line)
		
		if line.length() == 0:
			continue


		var matches = mul_regex.search_all(line)

		# Part 1
		for match in matches:
			var mul_str = match.get_string()
			var mul_idx = match.get_start()
			#print("mul_str ", mul_str, ", index ", mul_idx)
			
			#matches.push
			
			# Extract the 2 numbers
			var numbers = extract_numbers(mul_str)
			
			var product = numbers[0] * numbers[1]
			
			sum_of_mul += product


		# Part 2
		var do_matches = do_regex.search_all(line)
		var dont_matches = dont_regex.search_all(line)
		
		# combine all matches on base of their index
		var all = {}
		
		for match in matches:
			var str = match.get_string()
			var idx = match.get_start()
			all[idx] = str
		
		for match in do_matches:
			var str = match.get_string()
			var idx = match.get_start()
			all[idx] = str
		
		for match in dont_matches:
			var str = match.get_string()
			var idx = match.get_start()
			all[idx] = str

		#print("all: ", all)
		
		for i in range(0, line.length()):
			if all.has(i):
				var item = all[i]
				if item.begins_with("mul"):
					all_arr.push_back(all[i])
				elif item.begins_with("do("):
					all_arr.push_back(1)
				elif item.begins_with("don"):
					all_arr.push_back(0)


	print("all_arr: ", all_arr)
	
	var is_dont = false
	for item in all_arr:
		if item == 0:
			is_dont = true
		elif item == 1:
			is_dont = false





	# Part 1 - Right answer:
	print("Part 1 sum_of_mul: ", sum_of_mul)

	# Part 2 - Right answer: 
	print("Part 2: ", )




func run_puzzle():
	print("Puzzle 03")
	
	var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03_example.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_03_part_2_example.txt", FileAccess.READ)
	var content = puzzle.get_as_text()
	
	var lines = content.split('\n')
	
	process_lines(lines)

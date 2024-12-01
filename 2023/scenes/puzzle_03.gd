extends Node


var digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

var gears = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func chr_is_number(chr):
	return digits.has(chr)

func chr_is_symbol(chr):
	return !chr_is_number(chr) && chr != "."
	
func determine_adjacent_symbol(idx, str, line_length, found_nr_idx):
	# calc indices for all 8 adjacent neighbours of the current index (idx)
	var top_left = idx - line_length - 1
	var top = top_left + 1
	var top_right = top + 1
	var right = top_right + line_length
	var bottom_right = right + line_length
	var bottom = bottom_right - 1
	var bottom_left = bottom - 1
	var left = bottom_left - line_length
	
	
	# determine which neighbor is possible and check only those
	var neighbors = []
	
	var has_left_neighbor = idx % line_length >= 1
	var has_top_neighbor = idx >= line_length
	var has_right_neighbor = idx % line_length < line_length - 1
	var has_bottom_neighbor = idx < str.length() - line_length
	
	if has_top_neighbor && has_left_neighbor:
		neighbors.append(top_left)
	
	if has_top_neighbor:
		neighbors.append(top)
		
	if has_top_neighbor && has_right_neighbor:
		neighbors.append(top_right)
		
	if has_right_neighbor:
		neighbors.append(right)
	
	if has_bottom_neighbor && has_right_neighbor:
		neighbors.append(bottom_right)
		
	if has_bottom_neighbor:
		neighbors.append(bottom)
	
	if has_bottom_neighbor && has_left_neighbor:
		neighbors.append(bottom_left)
		
	if has_left_neighbor:
		neighbors.append(left)
	
	# loop over the neighbors and check for a symbol
	for neigh in neighbors:
		if str[neigh] == '*':
			# store the gear
			if !gears.has(neigh):
				gears[neigh] = {}
			
			gears[neigh][found_nr_idx] = found_nr_idx

		if chr_is_symbol(str[neigh]):
			return str[neigh]
		
	return false
	
func run_puzzle():
	print("Puzzle 03")
	
	var puzzle_03 = FileAccess.open("res://puzzle_input/puzzle_input_03.txt", FileAccess.READ)
	#var puzzle_03 = FileAccess.open("res://puzzle_input/puzzle_input_03_example.txt", FileAccess.READ)
	#var puzzle_03 = FileAccess.open("res://puzzle_input/puzzle_input_03_own_example.txt", FileAccess.READ)
	var content = puzzle_03.get_as_text()
	
	var lines = content.split('\n')
	
	var line_length = lines[0].length()
	
	print("line_length ", line_length)
	
	# put all lines in a 1-dimensional array for easier access to neighbors
	var str = ""
	for line in lines:
		str += line

	print(str)

	# find all numbers
	var current_number = ""
	var has_adjacent_symbol = false
	var loop_count = -1
	var parts = []  # all part numbers with an adjacent symbol
	var found_nr_idx = 0
	
	for chr in str:
		loop_count += 1
		
		if chr_is_number(chr):
			current_number += chr
			
			if determine_adjacent_symbol(loop_count, str, line_length, found_nr_idx):
				has_adjacent_symbol = true

			# check if we reached the rightest position to end current number
			if loop_count % line_length == line_length - 1:
				if has_adjacent_symbol:
					parts.append(current_number)
					found_nr_idx += 1
				
				current_number = ""
				has_adjacent_symbol = false
				
				
			# Part 2 - determine gear indicated by a star
			
		else:
			if current_number.length() > 0:
				#print("current_number ", current_number, ", has symbol: ", has_adjacent_symbol)
				
				if has_adjacent_symbol:
					parts.append(current_number)
					found_nr_idx += 1
				
				current_number = ""
				has_adjacent_symbol = false
				

	var parts_as_numbers = parts.map(func(nr): return nr.to_int())
	
	var sum = parts_as_numbers.reduce(func(accum, nr): return accum + nr, 0)
	
	print("sum ", sum)
	
	# Accumulate neighbors of found gears, if exactly 2 neighbors (Part 2)
	var sum_part_numbers_with_gears = 0
	for gear in gears.values():
		print(gear)
		
		if gear.keys().size() == 2:
			var product = 1
			for nr_idx in gear.keys():
				product *= parts_as_numbers[nr_idx]
		
			sum_part_numbers_with_gears += product
	
	print("sum of parts next to gears: ", sum_part_numbers_with_gears)

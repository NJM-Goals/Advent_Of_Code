extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

var card_count = 0

func process_lines(lines, idx_in_lines, all_lines):
	var sum = 0
	var loop_count = 0
	var copies = PackedStringArray()

	for line in lines:
		#print(line)
		
		if line.length() == 0:
			continue
		
		var line_arr = line.split(": ")
		var numbers = line_arr[1]
		var nr_arr = numbers.split(" | ")
		var left = nr_arr[0]
		var right = nr_arr[1]
		
		#print("left: '", left, "'")
		#print("right: '", right, "'")
		
		var left_nrs = left.split(" ")
		var right_nrs = right.split(" ")
		
		var points_current_line = 0
		var amount_additional_cards = 0  # Part 2
		for left_nr in left_nrs:
			if left_nr.length() == 0:
				continue
			
			var is_winning_nr = right_nrs.find(left_nr) != -1
			
			if is_winning_nr:
				#print("Winning number: ", left_nr)
				if  points_current_line == 0:
					points_current_line = 1
				else:
					points_current_line *= 2
					
				amount_additional_cards += 1

		var to_copy = all_lines.slice(idx_in_lines + loop_count + 1, idx_in_lines + loop_count + amount_additional_cards + 1)
		for copy in to_copy:
			copies.append(copy)

		loop_count += 1

		sum += points_current_line
		
		card_count += amount_additional_cards
		
		if copies.size() != 0:
			process_lines(copies, idx_in_lines + 1, all_lines)


func run_puzzle():
	print("Puzzle 04")
	
	#var puzzle_04 = FileAccess.open("res://puzzle_input/puzzle_input_04.txt", FileAccess.READ)
	var puzzle_04 = FileAccess.open("res://puzzle_input/puzzle_input_04_example.txt", FileAccess.READ)
	var content = puzzle_04.get_as_text()
	
	var lines = content.split('\n')
	
	var sum = 0
	var loop_count = 0
	var copies = []
	var overall_additional_cards = 0
	
	process_lines(lines, 0, lines)
	#for line in lines:
		##print(line)
		#
		#if line.length() == 0:
			#continue
		#
		#var line_arr = line.split(": ")
		#var numbers = line_arr[1]
		#var nr_arr = numbers.split(" | ")
		#var left = nr_arr[0]
		#var right = nr_arr[1]
		#
		##print("left: '", left, "'")
		##print("right: '", right, "'")
		#
		#var left_nrs = left.split(" ")
		#var right_nrs = right.split(" ")
		#
		#var points_current_line = 0
		#var amount_additional_cards = 0  # Part 2
		#for left_nr in left_nrs:
			#if left_nr.length() == 0:
				#continue
			#
			#var is_winning_nr = right_nrs.find(left_nr) != -1
			#
			#if is_winning_nr:
				##print("Winning number: ", left_nr)
				#if  points_current_line == 0:
					#points_current_line = 1
				#else:
					#points_current_line *= 2
					#
				#amount_additional_cards += 1
#
		#copies.append(lines.slice(loop_count + 1, loop_count + amount_additional_cards))
			#
		#loop_count += 1
		#
		#
		#sum += points_current_line
	
	# Part 1
	print("sum: ", sum)
	
	# Part 2	
	print("Amount copies ", copies.size())
	print("card count copies ", card_count)

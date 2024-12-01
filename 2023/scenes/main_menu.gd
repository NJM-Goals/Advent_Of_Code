extends Node2D

@onready var puzzle_03 = $Puzzle_03
@onready var puzzle_04 = $Puzzle_04

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu ready.")
	
	var is_puzzle_01 = false
	var is_puzzle_02 = false
	
	#puzzle_03.run_puzzle()
	
	puzzle_04.run_puzzle()
	
	
	# Puzzle 01
	if is_puzzle_01:
		var puzzle_01 = FileAccess.open("res://puzzle_input/puzzle_input_01.txt", FileAccess.READ)
		var content = puzzle_01.get_as_text()
		
		var lines = content.split('\n')
		
		var digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
		var written_digits = ["zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
		
		var sum = 0
		var sum_with_written_numbers = 0  # part two of the task
		
		for line in lines:
			#print("Line: ", line)
			
			if line.is_empty():
				continue
			
			var chars = line.split()
			
			var first_digit = ""
			var first_digit_idx = -1
			var last_digit = ""
			var last_digit_idx = -1
			
			var char_idx = 0
			
			for char in chars:
				var is_digit = digits.find(char) > 0;
				
				# determine first digit
				if is_digit and first_digit_idx < 0:
					first_digit = char
					first_digit_idx = char_idx
				
				# determine last digit
				if is_digit:
					last_digit = char
					last_digit_idx = char_idx
				
				char_idx += 1

			var nr_as_string = first_digit + last_digit
			var nr = nr_as_string.to_int()
			#print(nr)
			
			sum += nr;

			
			# Needed for Part 2 of the task
			# Find the first and last written digits like "one" or "four"
			var first_written_digit_idx = 35000
			var last_written_digit_idx = -1
			var first_written_nr = -1
			var last_written_nr = -1
			var loop_count = 0;
			for written_digit in written_digits:
				var first_idx = line.find(written_digit)
				if first_idx != -1 and first_idx < first_written_digit_idx:
					first_written_digit_idx = first_idx
					first_written_nr = loop_count
					
				var last_idx = line.rfind(written_digit)
				if last_idx != -1 and last_idx > last_written_digit_idx:
					last_written_digit_idx = last_idx
					last_written_nr = loop_count
				
				loop_count += 1
			
			#print("first_written_digit_idx ", first_written_digit_idx)
			#print("first_written_nr ", first_written_nr)
			#print("last_written_digit_idx ", last_written_digit_idx)
			#print("last_written_nr ", last_written_nr)
			
			var front = null
			var back = null
			
			# take the front number
			if first_digit_idx != -1 and first_digit_idx <= first_written_digit_idx:
				front = str(first_digit)
			if first_written_digit_idx != -1 and first_written_digit_idx < first_digit_idx:
				front = str(first_written_nr)
				
			# take the back number
			if last_digit_idx != -1 and last_digit_idx >= last_written_digit_idx:
				back = str(last_digit)
			if last_written_digit_idx != -1 and last_written_digit_idx > last_digit_idx:
				back = str(last_written_nr)
				
			print("front back: ", front, " ", back)
			
			if front == null or back == null:
				print("ERROR")
			
			var number_as_string = front + back
			#print("number_as_string ", number_as_string)
			sum_with_written_numbers += number_as_string.to_int()

		
		puzzle_01.close()
		
		print("Sum: ", sum)
		print("Sum with written numbers: ", sum_with_written_numbers)
		
	# Puzzle 02
	if is_puzzle_02:
		puzzle_02()


func puzzle_02():
	var puzzle_02 = FileAccess.open("res://puzzle_input/puzzle_input_02.txt", FileAccess.READ)
	#var puzzle_02 = FileAccess.open("res://puzzle_input/puzzle_input_02_example.txt", FileAccess.READ)
	var content = puzzle_02.get_as_text()
	
	var lines = content.split('\n')
	
	# create an array of all games to strike through those, that are not possible
	var possible_games = []
	for i in range(lines.size()):
		possible_games.append(i)
		
	var sum_of_fewest_cubes = 0;  # for Part 2
	
	var loop_count = -1;
	for line in lines:
		loop_count += 1
		
		var game_id = loop_count + 1
		
		if line.is_empty():
			continue
			
		var after_colon = line.split(": ")[1]
		#print(after_colon)
		
		
		# for Part 2
		var max_red = 1;
		var max_green = 1;
		var max_blue = 1;
		
		var draws = after_colon.split("; ")
		for draw in draws:
			#print(draw)
			
			var colors = draw.split(", ")
			
			for color in colors:
				#print(color)
				
				var amount_and_color = color.split(" ")
				var amount_str = amount_and_color[0]
				var color_str = amount_and_color[1]
				
				var amount = amount_str.to_int()
				if color_str == "red" and amount > 12:
					possible_games.erase(game_id)
					
				if color_str == "green" and amount > 13:
					possible_games.erase(game_id)
				
				if color_str == "blue" and amount > 14:
					possible_games.erase(game_id)

				# for Part 2
				if color_str == "red" and amount > max_red:
					max_red = amount;
				elif color_str == "green" and amount > max_green:
					max_green = amount
				elif color_str == "blue" and amount > max_blue:
					max_blue = amount
					
		var fewest_cubes = max_red * max_green * max_blue
		#print("fewest_cubes ", fewest_cubes)
		
		sum_of_fewest_cubes += fewest_cubes

	# Sum up the game IDs
	var sum_of_possible_games = possible_games.reduce(func(accum, number): return accum + number, 0)
	
	print("sum_of_possible_games: ", sum_of_possible_games)
	
	print("sum_of_fewest_cubes: ", sum_of_fewest_cubes)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

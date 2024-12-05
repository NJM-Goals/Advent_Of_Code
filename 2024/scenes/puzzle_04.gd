
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func arr_to_str(str_arr):
	var str = ""
	for char in str_arr:
		str += char
	
	return str


func lines_to_words(lines):
	var words = ""
	for line in lines:
		words += "  " + line
	return words


func reverse_string(str):
	var reversed = ""
	var reversed_arr = []
	for char in str:
		reversed_arr.push_front(char)
	
	for char in reversed_arr:
		reversed += char
		
	return reversed


func get_top_down(lines):
	var top_down = []
	for col in range(lines[0].length()):
		var word = ""
		for line in lines:
			if line.length() == 0:
				continue
			word += line[col]
		top_down.push_back(word)
	
	return top_down


func traverse_arr_diagonally(forward_arr, line_length, lines_amount):
	var diag = ""
	var idx = 0
	var max_idx = forward_arr.size() - 1
	var row = 0
	var col = 0
	var start_col = 0
	var start_row = 0
	var word = ""
	var words = []
	while true:
		var curr_word_max_idx = col + row * line_length
		if start_row > 0:
			curr_word_max_idx = max_idx - start_row
		
		if idx > curr_word_max_idx:
			start_col += 1
			if start_col == line_length || start_row > 0:
				start_row += 1
				start_col = 0
			
			if start_row == lines_amount:
				break
			
			col = start_col
			row = start_row
			idx = row * line_length + col
			
			diag += "  "  # mark word end
			print("word: ", word)
			words.push_back(word)
			word = ""
		else:
			diag += forward_arr[idx]
			word += forward_arr[idx]

			idx += line_length + 1
			
			col = (col + 1) % line_length
			
			row = (row + 1) % lines_amount
		
	print("diagonal: ", diag)
	print("diagonal words: ", words)


func process_lines(lines):
	
	# Part 1 use a regex to find mul(x,y)
	var xmas_regex = RegEx.new()
	xmas_regex.compile(r'(XMAS)')

	var forward_arr = []
	var forward_str = ""
	var backward_arr = []

	var line_length = lines[0].length()
	print("line_length: ", line_length)
	var lines_amount = lines.size() - 1  # subtract last empty line
	print("lines_amount: ", lines_amount)

	for line in lines:

		if line.length() == 0:
			continue


		for char in line:
			forward_arr.push_back(char)
			forward_str += char
			backward_arr.push_front(char)

	print("forward_str: ", forward_str)
	
	
	# forward
	var forward_matches = xmas_regex.search_all(forward_str)
	var nr_forward = forward_matches.size()
	
	
	# backward
	var backward_str = arr_to_str(backward_arr)
	var backward_matches = xmas_regex.search_all(backward_str)
	var nr_backward = backward_matches.size()
	
	
	# diagonal top-left to bottom-right
	# First word should be: MSXMAXSAMX
	# Char indices:
	# 0, 11, 22 .. 99; 99 = col < max, row < max
	# 1, 12, 23 .. 89; 89: idx = (row - start_row) * line_length + col
	# ..
	# 10 21 32 43 54 65 76 87 98; 
	# 80, 81
	# 90

	var diag = ""
	var idx = 0
	var max_idx = forward_arr.size() - 1
	var row = 0
	var col = 0
	var start_col = 0
	var start_row = 0
	var word = ""
	var words = []
	while true:
		var curr_word_max_idx = col + row * line_length
		if start_row > 0:
			curr_word_max_idx = max_idx - start_row
		
		if idx > curr_word_max_idx:
			start_col += 1
			if start_col == line_length || start_row > 0:
				start_row += 1
				start_col = 0
			
			if start_row == lines_amount:
				break
			
			col = start_col
			row = start_row
			idx = row * line_length + col
			
			diag += "  "  # mark word end
			print("word: ", word)
			words.push_back(word)
			word = ""
		else:
			diag += forward_arr[idx]
			word += forward_arr[idx]

			idx += line_length + 1
			
			col = (col + 1) % line_length
			
			row = (row + 1) % lines_amount
		
	print("diagonal: ", diag)
	print("diagonal words: ", words)
	var diag_matches = xmas_regex.search_all(diag)
	var nr_diag = diag_matches.size()
	

	# diagonal bottom-right to top-left
	var diag_br_tl = reverse_string(diag)
	var diag_matches_br_tl = xmas_regex.search_all(diag_br_tl)
	var nr_diag_br_tl = diag_matches_br_tl.size()
	
	
	# vertical top down
	var lines_td = get_top_down(lines)
	var words_td = lines_to_words(lines_td)
	print("words_td: ", words_td)
	var matches_td = xmas_regex.search_all(words_td)
	var nr_td = matches_td.size()


	# vertical bottom up
	var words_bu = reverse_string(words_td)
	var matches_bu = xmas_regex.search_all(words_bu)
	var nr_bu = matches_bu.size()
	
	
	print("nr_forward: ", nr_forward)
	print("nr_backward: ", nr_backward)
	print("nr_diag: ", nr_diag)
	print("nr_diag_br_tl: ", nr_diag_br_tl)
	print("nr_td: ", nr_td)
	print("nr_bu: ", nr_bu)


	var all_xmas = nr_forward + nr_backward + nr_diag + nr_diag_br_tl + nr_td + nr_bu


	# Part 1 - Right answer: 
	print("Part 1 all_xmas: ", all_xmas)

	# Part 2 - Right answer: 
	print("Part 2 : ")


func run_puzzle():
	print("Puzzle 04")
	
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_04.txt", FileAccess.READ)
	var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_04_example.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_04_part_2_example.txt", FileAccess.READ)
	var content = puzzle.get_as_text()
	
	var lines = content.split('\n')
	
	process_lines(lines)

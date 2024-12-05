
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func lines_to_char_arr(lines):
	var arr = []
	for line in lines:

		if line.length() == 0:
			continue

		for char in line:
			arr.push_back(char)
	return arr


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


func print_lines(caption, lines):
	print(caption)
	for line in lines:
		print("  ", line)


# Traverses a 1-dimensional array of chars diagonally as if it were 2-dimensional from top-left to bottom-right.
# Some considerations on base of example input.
# Char indices:
# 0, 11, 22 .. 99; 99 = col < max, row < max
# 1, 12, 23 .. 89; 89: idx = (row - start_row) * line_length + col
# ..
# 10 21 32 43 54 65 76 87 98; 
# 80, 81
# 90
func traverse_arr_diagonally(arr, line_length, lines_amount):
	var diag = ""
	var idx = 0
	var max_idx = arr.size() - 1
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
			#print("word: ", word)
			words.push_back(word)
			word = ""
		else:
			diag += arr[idx]
			word += arr[idx]

			idx += line_length + 1
			
			col = (col + 1) % line_length
			
			row = (row + 1) % lines_amount
		
	#print("diagonal: ", diag)
	#print("diagonal words: ", words)
	
	return diag


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
		
		forward_str += " "

	#print("forward_str: ", forward_str)
	
	
	# forward
	var forward_matches = xmas_regex.search_all(forward_str)
	var nr_forward = forward_matches.size()
	
	
	# backward
	var backward_str = reverse_string(forward_str)
	var backward_matches = xmas_regex.search_all(backward_str)
	var nr_backward = backward_matches.size()
	
	
	# diagonal top-left to bottom-right
	var diag = traverse_arr_diagonally(forward_arr, line_length, lines_amount)
	var diag_matches = xmas_regex.search_all(diag)
	var nr_diag = diag_matches.size()
	

	# diagonal bottom-right to top-left
	var diag_br_tl = reverse_string(diag)
	var diag_matches_br_tl = xmas_regex.search_all(diag_br_tl)
	var nr_diag_br_tl = diag_matches_br_tl.size()
	
	
	# diagonal bottom-left to top-right
	#   1. mirror top to bottom
	#   2. mirror right to left
	# ad 1.
	var lines_reversed = []
	#var lines_reversed = lines
	for line in lines:
		if line.length() == 0:
			continue
		lines_reversed.push_front(line)
	# ad 2.
	#var mirrored = []
	var mirrored = lines_reversed
	#for line in lines_reversed:
		#var word_reversed = ""
		#for char in line:
			#word_reversed = char + word_reversed
		#mirrored.push_back(word_reversed)
	
	#print_lines("mirrored: ", mirrored)
	var mirrored_arr = lines_to_char_arr(mirrored)
	var diag_bl_tr = traverse_arr_diagonally(mirrored_arr, line_length, lines_amount)
	var diag_matches_bl_tr = xmas_regex.search_all(diag_bl_tr)
	var nr_diag_bl_tr = diag_matches_bl_tr.size()


	# diagonal top-right to bottom-left
	var diag_tr_bl = reverse_string(diag_bl_tr)
	var diag_matches_tr_bl = xmas_regex.search_all(diag_tr_bl)
	var nr_diag_tr_bl = diag_matches_tr_bl.size()
	
	
	# vertical top down
	var lines_td = get_top_down(lines)
	var words_td = lines_to_words(lines_td)
	#print("words_td: ", words_td)
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
	print("nr_diag_tr_bl: ", nr_diag_tr_bl)
	print("nr_diag_bl_tr: ", nr_diag_bl_tr)
	print("nr_td: ", nr_td)
	print("nr_bu: ", nr_bu)


	var all_xmas = nr_forward + nr_backward + nr_diag + nr_diag_br_tl + nr_td + nr_bu + nr_diag_bl_tr + nr_diag_tr_bl


	# Part 1 - Right answer: 2534
	# Wrong 2559 too high.
	# Wrong 2536 too high. Site says, that it is a solution of someone else's input.
	# Wrong 2535 too high.
	print("Part 1 all_xmas: ", all_xmas)


func process_lines_part_2(lines):
	var cols = lines[0].length()
	print("cols: ", cols)
	var rows = lines.size() - 1  # subtract last empty line
	print("rows: ", rows)
	
	# Part 2 considerations
	# Use a 3x3 frame and move it on the input
	# Check this frame against possible X-MAS combinations
	
	var patterns = create_all_XMAS()
	#print("patterns", patterns)
	
	var arr = append_lines_to_1_dim_array(lines)
	var frames = get_all_frames(arr, cols, rows)
	#print("frames: ", frames.size(), " ", frames)
	
	var amount_xmas = count_xmasses(frames, patterns)
	
	# Part 2 - correct: 1866
	print("Part 2 amount_xmas: ", amount_xmas)


func create_all_XMAS():
	var xmasses = [
		"M.M" +
		".A." +
		"S.S",
		
		"M.S" +
		".A." +
		"M.S",
		
		"S.M" +
		".A." +
		"S.M",
		
		"S.S" +
		".A." +
		"M.M"
	]
	
	return xmasses


func count_xmasses(frames, patterns):
	var count = 0
	for frame in frames:
		for pattern in patterns:
			var is_xmas = compare_pattern_to_frame(pattern, frame)
			if is_xmas:
				count += 1
	
	return count


func compare_pattern_to_frame(pattern, frame):
	# indices that must be equal
	var indices = [0, 2, 4, 6, 8]
	for i in indices:
		var p =  pattern[i]
		var f = frame[i]
		if p != f:
			return false
	return true


func get_all_frames(arr, cols, rows):
	var frame_size = 2
	var max_cols = cols - frame_size
	var max_rows = rows - frame_size
	var frames = []
	for row in range(max_rows):
		for col in range(max_cols):
			var idx = col + row * cols
			var frame = get_frame_at_pos(arr, idx, cols)
			frames.push_back(frame)
	return frames


func get_frame_at_pos(arr, idx, cols):
	var indices = [
		idx, idx + 1, idx + 2,
		idx + cols, idx + cols + 1, idx + cols + 2,
		idx + 2 * cols, idx + 2 * cols + 1, idx + 2 * cols + 2,
	]
	
	var frame = []
	for i in indices:
		frame.push_back(arr[i])
	
	return frame


func append_lines_to_1_dim_array(lines):
	var arr = []
	for line in lines:
		if line.length() == 0:
			continue
		
		for char in line:
			arr.push_back(char)
	return arr


func run_puzzle():
	print("Puzzle 04")
	
	var puzzles = []
	var a = "res://puzzle_input/puzzle_input_04.txt"
	var b = "res://puzzle_input/puzzle_input_04_example.txt"
	var c = "res://puzzle_input/puzzle_input_04_example_2.txt"
	var paths = [c, b, a]
	#var paths = [b, c]
	
	for path in paths:
		var puzzle = FileAccess.open(path, FileAccess.READ)
		var content = puzzle.get_as_text()
	
		var lines = content.split('\n')
	
		#process_lines(lines)
		
		process_lines_part_2(lines)


extends Node

var utils = null

var lines_global = null
const nr_operations = 2

var cols = 0
var rows = 0

var debug_file : FileAccess = null

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


func extract_line(lines):
	var results = []
	var operands = []
	for line in lines:
		if line.length() == 0:
			continue
		
		var splits = line.split(':', false)
		var result = int(splits[0])
		results.push_back(result)
		var operands_line = splits[1].split(' ', false)
		operands.push_back(operands_line)
	return [results, operands]


# from Google Gemini - fixed by me
func int_to_binary_string(num):
	var binary_str = ""
	while num > 0:
		binary_str = str(int(num) % 2) + binary_str
		num = int(num / 2)
	return binary_str


func calc_bin_combis(nr_combi, nr_operators):
	var combis = []
	for i in range(nr_combi):
		var str = int_to_binary_string(i)
		var amount_chars = nr_operators
		str = str.lpad(amount_chars, "0")
		combis.push_back(str)
	
	#print("combis: ", combis)
	return combis


func calc(combi_str, operands):
	var calced = int(operands[0])
	var idx = 1
	for binary in combi_str:
		var num = int(operands[idx])
		if binary == "0":  # add
			calced += num
		if binary == "1":  # mul
			calced *= num

		idx += 1
	
	return calced

func calc_line(operands):
	var nr_operators = operands.size() - 1
	var nr_combi = pow(nr_operations, nr_operators)
	
	var combis_str = calc_bin_combis(nr_combi, nr_operators)
	# with three operands:
	# add add
	# add mul
	# mul add
	var line_results = []
	for combi_str in combis_str:
		var calced = calc(combi_str, operands)
		line_results.push_back(calced)
	
	return line_results


func calc_lines(operands):
	var line_results = []
	for i in range(operands.size()):
		var line_res = calc_line(operands[i])
		line_results.push_back(line_res)
	return line_results


func check_calced(results, calced):
	var correct_calcs = []
	for i in range(results.size()):
		var res = results[i]
		var calcs = calced[i]
		for calc in calcs:
			if res == calc:
				correct_calcs.push_back(calc)
				break

	return correct_calcs


func sum_of_arr(arr):
	var sum = 0
	for i in arr:
		sum += i
	return sum


func process_lines(lines):
	lines_global = lines
	cols = lines[0].length()
	print("cols: ", cols)
	rows = lines.size() - 1  # subtract last empty line
	print("rows: ", rows)
	
	
	var results = []
	var line_arr = extract_line(lines)
	results = line_arr[0]
	#print("results: ", results)
	var operands = []
	operands = line_arr[1]
	#print("operands: ", operands)
	
	var calced = []
	calced = calc_lines(operands)
	#print("calced: ", calced)
	
	var correct_results = check_calced(results, calced)
	#print("correct_results: ", correct_results)
	var sum = sum_of_arr(correct_results)


	# Part 1 - Right answer: 538191549061
	print("Part 1 sum: ", sum)
	
	# Part 2 - Right answer: 
	print("Part 2 : ", )


func run_puzzle(utils_in):
	print("Puzzle 07")
	
	utils = utils_in
	
	
	var puzzles = []
	var a = "res://puzzle_input/puzzle_input_07.txt"
	var b = "res://puzzle_input/puzzle_input_07_example.txt"
	var paths = [b, a]
	#var paths = [b]
	#var paths = [a]
	
	var debug_path = "res://puzzle_input/puzzle_output_07.txt"
	debug_file = FileAccess.open(debug_path, FileAccess.WRITE)
	
	for path in paths:
		var puzzle = FileAccess.open(path, FileAccess.READ)
		var content = puzzle.get_as_text()
	
		var lines = content.split('\n')
	
		#utils.print_lines("Puzzle input: ", lines)
		process_lines(lines)
	

func write_debug(lines, pos):
	debug_file.seek(0)  # overwrite content
	for line in lines:
		debug_file.store_string(line + '\n')
	debug_file.store_string('\n' + str(pos[0]) + " " + str(pos[1]))

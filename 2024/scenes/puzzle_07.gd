
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


func int_to_tertiary_string(num):
	var tertiary_str = ""
	while num > 0:
		tertiary_str = str(int(num) % 3) + tertiary_str
		num = int(num / 3)
	return tertiary_str


func calc_bin_combis(nr_combi, nr_operators):
	var combis = []
	for i in range(nr_combi):
		var str = int_to_binary_string(i)
		var amount_chars = nr_operators
		str = str.lpad(amount_chars, "0")
		combis.push_back(str)
	
	#print("combis: ", combis)
	return combis


func calc_ter_combis(nr_combi, nr_operators):
	var combis = []
	for i in range(nr_combi):
		var str = int_to_tertiary_string(i)
		var amount_chars = nr_operators
		str = str.lpad(amount_chars, "0")
		combis.push_back(str)
	
	#print("combis: ", combis)
	return combis

func calc(combi_str, operands):
	var calced = int(operands[0])
	#for idx in range(1, combi_str.length()):
	var idx = 1
	#var calced = 0
	for op_indicator in combi_str:
		var num = int(operands[idx])
		if op_indicator == "2":  # "||" is concatenation (Part 2)
			calced = str(calced) + str(num)
			calced = int(calced)
			#idx += 1
			#op_indicator = combi_str[idx]
			#num = int(operands[idx])
		
		if idx > combi_str.length():
			break
		
		if op_indicator == "0":  # add
			calced += num
		elif op_indicator == "1":  # mul
			calced *= num
		
		idx += 1
	
	return calced

func calc_line(operands):
	if operands.size() == 1:
		return [operands[0]]

	var nr_operators = operands.size() - 1
	var nr_combi = pow(nr_operations, nr_operators)
	
	var combis_str = calc_bin_combis(nr_combi, nr_operators)
	var nr_combi_ter = pow(nr_operations + 1, nr_operators)
	var combis_str_ter = calc_ter_combis(nr_combi_ter, nr_operators)
	#print("combis_str_ter: ", combis_str_ter)
	# with three operands and two operations:
	# add add
	# add mul
	# mul add
	#var line_results = []
	#for combi_str in combis_str:
		#var calced = calc(combi_str, operands)
		#line_results.push_back(calced)
		
	var line_results_concat = []
	for combi_str in combis_str_ter:
		var calced = calc(combi_str, operands)
		line_results_concat.push_back(calced)
	
	return line_results_concat


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



# wrong, because it treats the "||" with precedence
func create_concats_wrong(operands):
	var concats = []
	var concats_by_line = {}
	var line_idx = 0
	for ops in operands:
		var nr_concats = ops.size() - 1
		var new_ops = []
		for conc_pos in range(nr_concats):
			var conc_line = []
			for before_conc in range(conc_pos):
				conc_line.push_back(int(ops[before_conc]))
			var conc = int(str(ops[conc_pos]) + str(ops[conc_pos + 1]))
			conc_line.push_back(conc)
			for after_conc in range(conc_pos + 2, ops.size()):
				conc_line.push_back(int(ops[after_conc]))
			new_ops.push_back(conc_line)
			concats.push_back(conc_line)
		concats_by_line[line_idx] = new_ops
		line_idx += 1
		#print("new_ops", new_ops)
	return [concats, concats_by_line]


func check_concats(results, concats_by_line):
	var sum = 0
	var calcs = {}
	for line_idx in range(results.size()):
		var concs_line = concats_by_line[line_idx]
		#for operands in concs_line:
		var calced = []
		calced = calc_lines(concs_line)
		calcs[line_idx] = calced
		
		# check against res
		var equals = false
		var res = results[line_idx]
		for cal in calced:
			for calc in cal:
				if calc == res:
					equals = true
					break
			if equals:
				break
		if equals:
			sum += res
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
	
	
	# Part 2: Third operator "||" concatenates two numbers
	#	7290: 6 8 6 15 can be made true using 6 * 8 || 6 * 15.
	#	6 * 8 || 6 * 15
	#	6 * 8 = 48
	#	48 || 6 = 486
	#	486 * 15 = 7290
	#var res = create_concats_wrong(operands)
	#var operands_with_concats = res[0]
	#var concats_by_line = res[1]
	#print("operands_with_concats: ", operands_with_concats)
	#print("concats_by_line: ", concats_by_line)
	#var calced_concats = calc_lines(operands_with_concats)
	#print("calced_concats: ", calced_concats)
	#
	#var sum_of_concats = check_concats(results, concats_by_line)
	#print("sum_of_concats: ", sum_of_concats)


	# Part 1 - Right answer: 538191549061
	print("Part 1 sum: ", sum)
	
	# Part 2 - Right answer: 34612812972206
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

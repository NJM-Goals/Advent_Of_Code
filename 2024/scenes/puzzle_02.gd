
extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func is_safe_report(line_arr):
	var is_safe = true
	var is_increase = false
	
	for i in range(1, line_arr.size()):
		var diff = int(line_arr[i]) - int(line_arr[i-1])
		
		if abs(diff) > 3 or diff == 0:
			is_safe = false
			break
			
		if i == 1:
			is_increase = diff > 0
		
		if i > 1 and is_increase != (diff > 0):
			is_safe = false
			break
	
	return is_safe


func process_lines(lines):	
	var amount_safe_reports_part_1 = 0
	var amount_safe_reports_part_2 = 0

	for line in lines:
		#print(line)
		
		if line.length() == 0:
			continue
		
		var line_arr = line.split(" ")
		
		var is_safe_part_1 = is_safe_report(line_arr)
		var is_safe_part_2 = is_safe_part_1
		
		# Part 2 removes a level (one number) and then checks, if the report (line) is safe
		if !is_safe_part_1:
			is_safe_part_2 = false
			for i in range(0, line_arr.size()):
				var new_levels = line_arr.duplicate()
				new_levels.remove_at(i)

				is_safe_part_2 = is_safe_report(new_levels)
				if is_safe_part_2:
					break


		if is_safe_part_1:
			amount_safe_reports_part_1 += 1

		if is_safe_part_2:
			amount_safe_reports_part_2 += 1


	# Part 1 - Right answer: 564
	print("Safe reports part 1: ", amount_safe_reports_part_1)

	# Part 2 - Right answer: 604
	print("Safe reports part 2: ", amount_safe_reports_part_2)




func run_puzzle():
	print("Puzzle 02")
	
	var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_02.txt", FileAccess.READ)
	#var puzzle = FileAccess.open("res://puzzle_input/puzzle_input_02_example.txt", FileAccess.READ)
	var content = puzzle.get_as_text()
	
	var lines = content.split('\n')
	
	process_lines(lines)

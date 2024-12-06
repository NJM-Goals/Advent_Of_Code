
extends Node

var curr_rules = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func process_lines(lines):
	var lines_amount = lines.size() - 1  # subtract last empty line
	print("lines_amount: ", lines_amount)

	var rule_lines = []
	var update_lines = []
	var is_rule = true
	for line in lines:

		if line.length() == 0:
			is_rule = false
			continue
		
		if is_rule:
			rule_lines.push_back(line)
		else:
			update_lines.push_back(line)

	print("rule_lines: ", rule_lines)
	print("update_lines: ", update_lines)
	
	var rules = extract_rules(rule_lines)
	var updates = extract_updates(update_lines)
	
	var correct_updates = []  # Part 1
	var wrong_updates = []    # Part 2
	for update in updates:
		var i = 0
		var is_correct = true
		for up_item in update:
			var item_rules = get_rules_of_item(rules, up_item)
			if item_rules.size() != 0:
				is_correct = check(up_item, i, update, item_rules)
			i += 1
			
			if !is_correct:
				break
			
		if is_correct:
			correct_updates.push_back(update)
		else:
			wrong_updates.push_back(update)
	
	#print("updates: \t\t\t", updates.size(), " ", updates)
	#print("correct_updates: \t", correct_updates.size(), " ", correct_updates)
	
	# Part 1
	var sum_middles = calc_sum_middles(correct_updates)
	
	# Part 2
	var fixed_updates = fix_updates(wrong_updates, rules)
	var sum_middles_2 = calc_sum_middles(fixed_updates)

	# Part 1 - Right answer: 5762
	print("Part 1 sum_middles: ", sum_middles)
	
	# Part 2 - Right answer: 4130
	print("Part 2 sum_middles_2: ", sum_middles_2)


func fix_updates(updates, rules):
	var fixed = []
	for update in updates:
		var fixed_up = fix_update(update, rules)
		fixed.push_back(fixed_up)
	return fixed


func fix_update(update, rules):
	curr_rules = rules
	var arr = Array(update)
	arr.sort_custom(sort_update)
	return arr

func sort_update(a, b):
	var rules = curr_rules
	
	# find a rule, that contains both elements
	var found_rule = find_rule(rules, a, b)
	if found_rule == null:
		return true
	
	return a == found_rule.left


func find_rule(rules, a, b):
	for rule in rules:
		if rule.left == a and rule.right == b:
			return rule
		if rule.right == a and rule.left == b:
			return rule
	return null

func calc_sum_middles(arr):
	var sum = 0
	for nrs in arr:
		var size = nrs.size()
		var middle_idx = size / 2
		var middle_nr = int(nrs[middle_idx])
		print("middle_nr: ", middle_nr)
		sum += middle_nr
	return sum


func check(up, idx, update, rules):
	var is_ok = true
	
	# loop the whole update and check each rule
	var other_idx = 0
	for other in update:
		if other == up:
			other_idx += 1
			continue
		
		for rule in rules:
			var is_left = rule.left == up
			var is_right = rule.right == up
			
			if is_left == is_right:
				print("ERROR: up item cannot be left and right")
				return false
		
			if other_idx < idx:
				# if the other number is found on the right side,
				# the update is wrong
				if other == rule.right:
					return false
			elif other_idx > idx:
				if other == rule.left:
					return false
		
		other_idx += 1
		
	return true


func extract_rules(rule_lines):
	var rules = []
	for line in rule_lines:
		var rule = {}
		var numbers = line.split("|")
		rule.left = numbers[0]
		rule.right = numbers[1]
		rules.push_back(rule)
	return rules


func extract_updates(update_lines):
	var updates = []
	for line in update_lines:
		var numbers = line.split(",")
		updates.push_back(numbers)
	return updates


# finds all rules that contain item
func get_rules_of_item(rules, item):
	var findings = []
	for rule in rules:
		if rule.left == item or rule.right == item:
			findings.push_back(rule)
	
	return findings


func run_puzzle():
	print("Puzzle 05")
	
	var puzzles = []
	var a = "res://puzzle_input/puzzle_input_05.txt"
	var b = "res://puzzle_input/puzzle_input_05_example.txt"
	var paths = [b, a]
	#var paths = [b]
	
	for path in paths:
		var puzzle = FileAccess.open(path, FileAccess.READ)
		var content = puzzle.get_as_text()
	
		var lines = content.split('\n')
	
		process_lines(lines)
		
		#process_lines_part_2(lines)

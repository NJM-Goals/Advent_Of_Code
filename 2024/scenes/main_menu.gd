extends Node2D

@onready var puzzle_01 = $Puzzle_01
@onready var puzzle_02 = $Puzzle_02
@onready var puzzle_03 = $Puzzle_03
@onready var puzzle_04 = $Puzzle_04

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu ready.")
	
	#puzzle_01.run_puzzle()
	#puzzle_02.run_puzzle()
	#puzzle_03.run_puzzle()
	puzzle_04.run_puzzle()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

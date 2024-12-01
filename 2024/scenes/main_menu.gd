extends Node2D

@onready var puzzle_01 = $Puzzle_01

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Main menu ready.")
	
	puzzle_01.run_puzzle()
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	pass

extends Node2D

const SLOT_SCENE = preload("res://Slot.tscn")
const BOARD_WIDTH = 5
const BOARD_HEIGHT = 4

@onready var game_board = $GameBoard

func _ready():
	generate_board()

func generate_board():
	for i in range(BOARD_WIDTH * BOARD_HEIGHT):
		var new_slot = SLOT_SCENE.instantiate()
		game_board.add_child(new_slot)

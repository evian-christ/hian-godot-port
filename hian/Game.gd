extends Node2D

const SLOT_SCENE = preload("res://Slot.tscn")
const BOARD_WIDTH = 5
const BOARD_HEIGHT = 4

@onready var game_board = $GameBoard

func _ready():
	generate_board()
	place_initial_symbols()

func generate_board():
	for i in range(BOARD_WIDTH * BOARD_HEIGHT):
		var new_slot = SLOT_SCENE.instantiate()
		game_board.add_child(new_slot)

func place_initial_symbols():
	var available_slots = game_board.get_children()
	available_slots.shuffle()

	for i in range(min(GameManager.initial_symbols.size(), available_slots.size())):
		var symbol_data = GameManager.initial_symbols[i]
		var target_slot = available_slots[i]
		target_slot.set_symbol(symbol_data)

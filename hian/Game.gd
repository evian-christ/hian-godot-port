extends Node2D

const SLOT_SCENE = preload("res://Slot.tscn")
const SymbolData = preload("res://SymbolData.gd") # SymbolData 타입 추가
const BOARD_WIDTH = 5
const BOARD_HEIGHT = 4

@onready var game_board = $GameBoard
@onready var ui = $UI

func _ready():
	generate_board()
	place_symbols(GameManager.player_owned_symbols)
	calculate_food_production()
	ui.spin_requested.connect(_on_ui_spin_requested)

func generate_board():
	for i in range(BOARD_WIDTH * BOARD_HEIGHT):
		var new_slot = SLOT_SCENE.instantiate()
		game_board.add_child(new_slot)

func clear_board():
	for slot in game_board.get_children():
		slot.set_symbol(null)

func place_symbols(symbols_to_place: Array[SymbolData]):
	var available_slots = game_board.get_children()
	available_slots.shuffle()

	for i in range(min(symbols_to_place.size(), available_slots.size())):
		var symbol_data = symbols_to_place[i]
		var target_slot = available_slots[i]
		target_slot.set_symbol(symbol_data)

func calculate_food_production():
	var slots = game_board.get_children()
	for i in range(slots.size()):
		var slot = slots[i]
		if slot.current_symbol and slot.current_symbol.name == "Wild berries":
			GameManager.total_food += 1 # Base production
			
			# Synergy with Woods
			var x = i % BOARD_WIDTH
			var y = i / BOARD_WIDTH
			
			var neighbor_indices = []
			# Cardinal directions
			if x > 0: neighbor_indices.append(i - 1)
			if x < BOARD_WIDTH - 1: neighbor_indices.append(i + 1)
			if y > 0: neighbor_indices.append(i - BOARD_WIDTH)
			if y < BOARD_HEIGHT - 1: neighbor_indices.append(i + BOARD_WIDTH)
			# Diagonal directions
			if x > 0 and y > 0: neighbor_indices.append(i - BOARD_WIDTH - 1)
			if x < BOARD_WIDTH - 1 and y > 0: neighbor_indices.append(i - BOARD_WIDTH + 1)
			if x > 0 and y < BOARD_HEIGHT - 1: neighbor_indices.append(i + BOARD_WIDTH - 1)
			if x < BOARD_WIDTH - 1 and y < BOARD_HEIGHT - 1: neighbor_indices.append(i + BOARD_WIDTH + 1)
			
			for neighbor_index in neighbor_indices:
				var neighbor_slot = slots[neighbor_index]
				if neighbor_slot.current_symbol and neighbor_slot.current_symbol.name == "Woods":
					GameManager.total_food += 1

func _on_ui_spin_requested():
	GameManager.turn += 1
	clear_board()
	place_symbols(GameManager.player_owned_symbols)
	calculate_food_production()

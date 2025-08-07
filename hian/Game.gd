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
	ui.spin_requested.connect(_on_ui_spin_requested)

func generate_board():
	for i in range(BOARD_WIDTH * BOARD_HEIGHT):
		var new_slot = SLOT_SCENE.instantiate()
		game_board.add_child(new_slot)

func clear_board():
	for slot in game_board.get_children():
		slot.set_symbol(null)

func place_symbols(symbols_to_place: Array[SymbolData]): # 인자 타입 변경
	var available_slots = game_board.get_children()
	available_slots.shuffle()

	var placed_symbols: Array[SymbolData] = []
	for i in range(min(symbols_to_place.size(), available_slots.size())):
		var symbol_data = symbols_to_place[i]
		var target_slot = available_slots[i]
		target_slot.set_symbol(symbol_data)
		placed_symbols.append(symbol_data)

func _on_ui_spin_requested():
	GameManager.turn += 1
	clear_board()
	place_symbols(GameManager.player_owned_symbols)

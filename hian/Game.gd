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
	calculate_production()
	ui.spin_requested.connect(_on_ui_spin_requested)

func generate_board():
	for i in range(BOARD_WIDTH * BOARD_HEIGHT):
		var new_slot = SLOT_SCENE.instantiate()
		new_slot.board_position = Vector2i(i % BOARD_WIDTH, i / BOARD_WIDTH)
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

func calculate_production():
	GameManager.current_turn_food_production = 0

	var slots = game_board.get_children()

	# 1. Base Production
	for slot in slots:
		if slot.current_symbol:
			GameManager.current_turn_food_production += slot.current_symbol.base_production.get("food", 0)

	# 2. Synergy / Effect Production
	EffectEngine.process_turn_effects(self, slots)

	GameManager.total_food += GameManager.current_turn_food_production


func get_neighbor_slots(slot_index: int) -> Array:
	var neighbors = []
	var slots = game_board.get_children()
	var x = slot_index % BOARD_WIDTH
	var y = slot_index / BOARD_WIDTH

	var directions = [
		Vector2i(-1, -1), Vector2i(0, -1), Vector2i(1, -1),
		Vector2i(-1, 0),                 Vector2i(1, 0),
		Vector2i(-1, 1), Vector2i(0, 1), Vector2i(1, 1)
	]

	for dir in directions:
		var neighbor_pos = Vector2i(x, y) + dir
		if neighbor_pos.x >= 0 and neighbor_pos.x < BOARD_WIDTH and \
		   neighbor_pos.y >= 0 and neighbor_pos.y < BOARD_HEIGHT:
			var neighbor_index = neighbor_pos.y * BOARD_WIDTH + neighbor_pos.x
			neighbors.append(slots[neighbor_index])

	return neighbors

func _on_ui_spin_requested():
	GameManager.turn += 1
	clear_board()
	place_symbols(GameManager.player_owned_symbols)
	calculate_production()

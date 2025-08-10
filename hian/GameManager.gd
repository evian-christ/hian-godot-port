extends Node

var turn = 0
var total_food = 0
var current_turn_food_production = 0

# 플레이어가 소유한 초기 심볼 목록
var initial_symbols: Array[SymbolData] = [
	preload("res://resources/symbols/001_river.tres"),
	preload("res://resources/symbols/003_grassland.tres"),
]

# 플레이어가 현재 소유한 모든 심볼
var player_owned_symbols: Array[SymbolData] = []

func _ready():
	# 게임 시작 시 초기 심볼을 플레이어 소유 풀에 추가
	player_owned_symbols.append_array(initial_symbols)

func add_symbol_to_player_pool(symbol_data: SymbolData):
	player_owned_symbols.append(symbol_data)
	print("Added ", symbol_data.name, " to player's pool. Total owned: ", player_owned_symbols.size())

# 모든 심볼 리소스를 불러와 배열로 반환합니다.
func get_all_symbols() -> Array[SymbolData]:
	var all_symbols: Array[SymbolData] = []
	var dir = DirAccess.open("res://resources/symbols/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var path = "res://resources/symbols/" + file_name
				var symbol_data = load(path) as SymbolData
				if symbol_data:
					print("Loaded symbol: ", symbol_data.name)
					all_symbols.append(symbol_data)
			file_name = dir.get_next()
	else:
		print("Error: Could not open directory res://resources/symbols/")
	return all_symbols

# 세 개의 선택지 심볼을 생성하여 반환합니다.
func generate_selection_symbols() -> Array[SymbolData]:
	var all_symbols = get_all_symbols()
	all_symbols.shuffle()
	
	var selection_symbols: Array[SymbolData] = []
	var num_to_select = min(3, all_symbols.size()) # 심볼이 3개 미만일 경우를 대비
	
	for i in range(num_to_select):
		selection_symbols.append(all_symbols[i])
		
	return selection_symbols

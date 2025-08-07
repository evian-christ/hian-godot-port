extends Node

var turn = 0

# 플레이어가 소유한 초기 심볼 목록 (테스트용)
var initial_symbols: Array[SymbolData] = [
	preload("res://resources/symbols/fruits.tres"),
	preload("res://resources/symbols/wheat.tres"),
	preload("res://resources/symbols/cow.tres"),
]

# 플레이어가 현재 소유한 모든 심볼
var player_owned_symbols: Array[SymbolData] = []

# 모든 심볼을 희귀도별로 저장할 딕셔너리
var all_symbols_by_rarity: Dictionary = {}

# 현재 희귀도별 확률 (총합 100)
var current_rarity_probabilities: Dictionary = {
	SymbolData.Rarity.COMMON: 70,
	SymbolData.Rarity.UNCOMMON: 20,
	SymbolData.Rarity.RARE: 8,
	SymbolData.Rarity.EPIC: 2,
	SymbolData.Rarity.LEGENDARY: 0,
}

func _ready():
	_load_all_symbols()
	# 게임 시작 시 초기 심볼을 플레이어 소유 풀에 추가
	player_owned_symbols.append_array(initial_symbols)

func add_symbol_to_player_pool(symbol_data: SymbolData):
	player_owned_symbols.append(symbol_data)
	print("Added ", symbol_data.symbol_name, " to player's pool. Total owned: ", player_owned_symbols.size())

func _load_all_symbols():
	# 모든 희귀도 키 초기화
	for rarity_enum_value in SymbolData.Rarity.values():
		all_symbols_by_rarity[rarity_enum_value] = []

	var dir = DirAccess.open("res://resources/symbols/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".tres"):
				var path = "res://resources/symbols/" + file_name
				var symbol_data = load(path) as SymbolData
				if symbol_data:
					all_symbols_by_rarity[symbol_data.rarity].append(symbol_data)
				else:
					print("Warning: Could not load SymbolData from ", path)
			file_name = dir.get_next()
		print("Loaded symbols by rarity: ", all_symbols_by_rarity)
	else:
		print("Error: Could not open directory res://resources/symbols/")

# 현재 확률에 따라 무작위 희귀도를 선택합니다.
func _get_random_rarity() -> int:
	var total_weight = 0
	for weight in current_rarity_probabilities.values():
		total_weight += weight

	var random_value = randi() % total_weight
	var cumulative_weight = 0
	for rarity_enum_value in SymbolData.Rarity.values():
		var weight = current_rarity_probabilities.get(rarity_enum_value, 0)
		cumulative_weight += weight
		if random_value < cumulative_weight:
			return rarity_enum_value
	return SymbolData.Rarity.COMMON # Fallback

# 특정 희귀도에서 무작위 심볼을 반환합니다.
func get_random_symbol_by_rarity(rarity_enum_value: int) -> SymbolData:
	var symbols_of_rarity = all_symbols_by_rarity.get(rarity_enum_value, [])
	if symbols_of_rarity.is_empty():
		# 해당 희귀도에 심볼이 없으면 COMMON에서 가져오거나 null 반환
		print("Warning: No symbols found for rarity ", SymbolData.Rarity.keys()[rarity_enum_value], ". Returning random COMMON symbol.")
		return get_random_symbol_by_rarity(SymbolData.Rarity.COMMON) if not all_symbols_by_rarity[SymbolData.Rarity.COMMON].is_empty() else null
	return symbols_of_rarity[randi() % symbols_of_rarity.size()]

# 세 개의 선택지 심볼을 생성하여 반환합니다.
func generate_selection_symbols() -> Array[SymbolData]:
	var selection_symbols: Array[SymbolData] = []
	for i in range(3):
		var random_rarity = _get_random_rarity()
		var symbol = get_random_symbol_by_rarity(random_rarity)
		if symbol:
			selection_symbols.append(symbol)
		else:
			# 심볼을 찾지 못하면 null을 추가하거나, 오류 처리
			selection_symbols.append(null)
	return selection_symbols

extends Node

var turn = 0

# 플레이어가 소유한 초기 심볼 목록
var initial_symbols: Array[SymbolData] = [
	preload("res://resources/symbols/fruits.tres"),
	preload("res://resources/symbols/wheat.tres"),
	preload("res://resources/symbols/cow.tres"),
]

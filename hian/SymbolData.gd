# SymbolData.gd
class_name SymbolData
extends Resource

@export var id: int = 0
@export var name: String = ""
@export_range(0, 10) var level: int = 0

# 심볼의 타입을 정의하는 플래그 (여러 개 선택 가능)
@export_flags("Terrain", "Food")
var types: int = 0
@export var texture: Texture2D

# 심볼에 대한 설명
@export_multiline var description: String = ""

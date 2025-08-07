# SymbolData.gd
extends Resource

# 심볼의 등급을 정의하는 Enum (열거형)
enum Rarity { COMMON, UNCOMMON, RARE, EPIC, LEGENDARY }

@export var symbol_id: int = 0
@export var symbol_name: String = ""
@export var rarity: Rarity = Rarity.COMMON
@export var texture: Texture2D

# 심볼에 대한 설명
@export_multiline var description: String = ""

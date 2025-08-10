extends ColorRect

@onready var symbol_texture: TextureRect = $SymbolTexture
@onready var label: Label = $Label

var current_symbol: SymbolData = null
var is_empty: bool = true

func _ready():
	pass

func set_symbol(symbol_data: SymbolData):
	current_symbol = symbol_data
	is_empty = (symbol_data == null)
	
	if not is_empty:
		symbol_texture.texture = symbol_data.texture
		label.text = symbol_data.name
	else:
		symbol_texture.texture = null
		label.text = "-"

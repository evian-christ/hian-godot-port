extends ColorRect

@onready var symbol_texture = $SymbolTexture

var current_symbol = null

func _ready():
	pass

func set_symbol(symbol_data):
	current_symbol = symbol_data
	if symbol_data:
		symbol_texture.texture = symbol_data.texture
	else:
		symbol_texture.texture = null

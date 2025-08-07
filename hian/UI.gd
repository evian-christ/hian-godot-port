extends CanvasLayer

signal spin_requested
signal symbol_selected(symbol_data)

@onready var turn_label = $MarginContainer/VBoxContainer/TopRow/TurnLabel
@onready var select_button_1 = $MarginContainer/VBoxContainer/BottomRow/SelectButton1
@onready var select_button_2 = $MarginContainer/VBoxContainer/BottomRow/SelectButton2
@onready var select_button_3 = $MarginContainer/VBoxContainer/BottomRow/SelectButton3
@onready var spin_button = $MarginContainer/VBoxContainer/SpinButton

@onready var texture_rect_1 = $MarginContainer/VBoxContainer/BottomRow/SelectButton1/TextureRect1
@onready var texture_rect_2 = $MarginContainer/VBoxContainer/BottomRow/SelectButton2/TextureRect2
@onready var texture_rect_3 = $MarginContainer/VBoxContainer/BottomRow/SelectButton3/TextureRect3

var current_selection_symbols: Array[SymbolData] = []

func _ready():
	set_select_buttons_disabled(true)

func _process(delta):
	turn_label.text = "Turn: " + str(GameManager.turn)

func _on_spin_button_pressed():
	spin_requested.emit()
	set_select_buttons_disabled(false)
	spin_button.disabled = true

	current_selection_symbols = GameManager.generate_selection_symbols()

	_update_select_buttons()

func _on_select_button_1_pressed():
	print("Select Button 1 Pressed")
	symbol_selected.emit(current_selection_symbols[0])
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func _on_select_button_2_pressed():
	print("Select Button 2 Pressed")
	symbol_selected.emit(current_selection_symbols[1])
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func _on_select_button_3_pressed():
	print("Select Button 3 Pressed")
	symbol_selected.emit(current_selection_symbols[2])
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func set_select_buttons_disabled(disabled: bool):
	select_button_1.disabled = disabled
	select_button_2.disabled = disabled
	select_button_3.disabled = disabled

func _update_select_buttons():
	var buttons = [select_button_1, select_button_2, select_button_3]
	var textures = [texture_rect_1, texture_rect_2, texture_rect_3]

	for i in range(3):
		var symbol = current_selection_symbols[i]
		if symbol:
			buttons[i].text = symbol.symbol_name
			textures[i].texture = symbol.texture
		else:
			buttons[i].text = "(Empty)"
			textures[i].texture = null

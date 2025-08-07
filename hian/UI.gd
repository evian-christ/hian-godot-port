extends CanvasLayer

signal spin_requested

@onready var turn_label = $MarginContainer/VBoxContainer/TopRow/TurnLabel
@onready var select_button_1 = $MarginContainer/VBoxContainer/BottomRow/SelectButton1
@onready var select_button_2 = $MarginContainer/VBoxContainer/BottomRow/SelectButton2
@onready var select_button_3 = $MarginContainer/VBoxContainer/BottomRow/SelectButton3
@onready var spin_button = $MarginContainer/VBoxContainer/SpinButton

func _ready():
	set_select_buttons_disabled(true)

func _process(delta):
	turn_label.text = "Turn: " + str(GameManager.turn)

func _on_spin_button_pressed():
	spin_requested.emit()
	set_select_buttons_disabled(false)
	spin_button.disabled = true

func _on_select_button_1_pressed():
	print("Select Button 1 Pressed")
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func _on_select_button_2_pressed():
	print("Select Button 2 Pressed")
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func _on_select_button_3_pressed():
	print("Select Button 3 Pressed")
	set_select_buttons_disabled(true)
	spin_button.disabled = false

func set_select_buttons_disabled(disabled: bool):
	select_button_1.disabled = disabled
	select_button_2.disabled = disabled
	select_button_3.disabled = disabled

extends CanvasLayer

signal spin_requested

@onready var turn_label = $MarginContainer/VBoxContainer/TopRow/TurnLabel

func _process(delta):
	turn_label.text = "Turn: " + str(GameManager.turn)

func _on_spin_button_pressed():
	spin_requested.emit()

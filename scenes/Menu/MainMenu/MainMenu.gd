extends CanvasLayer

signal button_pressed(button_name)

onready var continue_button = $NinePatchRect/VBoxContainer/ContinueButton

func _ready():
	var data = GameState.load()
	continue_button.visible = data != null

func _on_StartButton_pressed():
	emit_signal("button_pressed", "start")

func _on_OptionsButton_pressed():
	emit_signal("button_pressed", "options")

func _on_QuitButton_pressed():
	emit_signal("button_pressed", "quit")

func _on_ContinueButton_pressed():
	emit_signal("button_pressed", "continue")

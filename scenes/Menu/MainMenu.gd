extends CanvasLayer

signal button_pressed(button_name)

func _on_StartButton_pressed():
	emit_signal("button_pressed", "start")

func _on_OptionsButton_pressed():
	emit_signal("button_pressed", "options")

func _on_InstructionsButton_pressed():
	emit_signal("button_pressed", "instructions")

func _on_QuitButton_pressed():
	emit_signal("button_pressed", "quit")

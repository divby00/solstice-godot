extends CanvasLayer

signal help_shown
signal help_hidden

onready var control = $Control
onready var close_button = $Control/CloseButton

var help_is_posible = true
var help_displayed = false

func _ready():
	set_process(false)

func _on_CloseButton_pressed():
	close_help()

func _process(_delta):
	if help_displayed:
		emit_signal("help_shown")

func _input(_event):
	if Input.is_action_just_pressed("help") and help_is_posible:
		var new_state = !control.visible
		if new_state:
			control.visible = true
			get_tree().paused = true
			help_displayed = true
			set_process(true)
		else:
			close_help()

func close_help():
	control.visible = false
	get_tree().paused = false
	help_displayed = false
	emit_signal("help_hidden")
	set_process(false)

func _on_Pause_pause_hidden():
	help_is_posible = true

func _on_Pause_pause_shown():
	help_is_posible = false

extends CanvasLayer

signal fadein_finished
signal fadeout_finished

const circle_in: AnimatedTexture = preload("res://scenes/Transitions/circle_in.tres")
const circle_out: AnimatedTexture = preload("res://scenes/Transitions/circle_out.tres")

onready var fading = $Fading
onready var timer_in = $TimerIn
onready var timer_out = $TimerOut

func fadein():
	circle_in.current_frame = 0
	circle_in.oneshot = true
	fading.texture = circle_in
	timer_in.start()

func _on_TimerIn_timeout():
	emit_signal("fadein_finished")

func fadeout():
	circle_out.current_frame = 0
	circle_out.oneshot = true
	fading.texture = circle_out
	timer_out.start()

func _on_TimerOut_timeout():
	emit_signal("fadeout_finished")

extends CanvasLayer

signal fadein_finished(transition_name)
signal fadeout_finished(transition_name)

export(AnimatedTexture) var circle_in
export(AnimatedTexture) var circle_out

onready var fading = $Fading
onready var timer_in = $TimerIn
onready var timer_out = $TimerOut

var transition_name
var running = false

func _ready():
	fading.hide()

func fadein(transition_name="transition"):
	self.transition_name = transition_name
	fading.show()
	circle_in.current_frame = 0
	circle_in.oneshot = true
	fading.texture = circle_in
	timer_in.start()
	running = true

func _on_TimerIn_timeout():
	fading.hide()
	running = false
	emit_signal("fadein_finished", transition_name)

func fadeout(transition_name="transition"):
	self.transition_name = transition_name
	fading.show()
	circle_out.current_frame = 0
	circle_out.oneshot = true
	fading.texture = circle_out
	timer_out.start()
	running = true

func _on_TimerOut_timeout():
	fading.hide()
	running = false
	emit_signal("fadeout_finished", transition_name)


extends Node2D

const dither_out: AnimatedTexture = preload("res://scenes/Love4Retro/dither_out.tres")

onready var timer_idle = $TimerIdle
onready var timer_out = $TimerOut
onready var fading = $Fading

func _on_TimerIn_timeout():
	SoundFx.play("love4retro")
	timer_idle.start()

func _on_TimerIdle_timeout():
	dither_out.current_frame = 0
	dither_out.oneshot = true
	fading.texture = dither_out
	timer_out.start()

func _on_TimerOut_timeout():
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")


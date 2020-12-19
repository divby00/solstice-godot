extends Node2D

onready var timer = $Timer
onready var fade_transition = $FadeTransition

func _ready():
	fade_transition.fadein()

func _on_FadeTransition_fadein_finished():
	SoundFx.play("love4retro")
	timer.start()

func _on_Timer_timeout():
	fade_transition.fadeout()

func _on_FadeTransition_fadeout_finished():
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")

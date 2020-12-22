extends Node2D

onready var timer = $Timer
onready var voice_timer = $VoiceTimer
onready var transition = $CircleTransition

func _ready():
	transition.fadein()
	SoundFx.play_with_priority("nuclear_explosion")

func _on_Timer_timeout():
	transition.fadeout()

func _on_CircleTransition_fadein_finished(_transition_name):
	timer.start()
	voice_timer.start()

func _on_CircleTransition_fadeout_finished(_transition_name):
	visible = false
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")

func _on_VoiceTimer_timeout():
	SoundFx.play("game_over")

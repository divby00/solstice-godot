extends Node2D

onready var timer = $Timer
onready var transition = $CircleTransition

const Cursor = preload("res://scenes/Player/big_cursor.png")

func _ready():
	Configuration.load_and_save_config()
	transition.fadein()

func _on_CircleTransition_fadein_finished(_transition_name):
	SoundFx.play("love4retro")
	timer.start()

func _on_Timer_timeout():
	transition.fadeout()

func _on_CircleTransition_fadeout_finished(_transition_name):
	visible = false
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")

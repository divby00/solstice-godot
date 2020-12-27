extends Node2D

onready var timer = $Timer
onready var voice_timer = $VoiceTimer
onready var transition = $CircleTransition
onready var voice_audio_player = $VoiceAudioPlayer
onready var explosion_audio_player = $ExplosionAudioPlayer

func _ready():
	transition.fadein()
	explosion_audio_player.play()

func _on_Timer_timeout():
	transition.fadeout()

func _on_CircleTransition_fadein_finished(_transition_name):
	timer.start()
	voice_timer.start()

func _on_CircleTransition_fadeout_finished(_transition_name):
	visible = false
	get_tree().change_scene_to(ResourceLoader.Intro)

func _on_VoiceTimer_timeout():
	voice_audio_player.play()

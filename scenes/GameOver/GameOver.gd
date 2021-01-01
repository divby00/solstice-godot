extends Node2D

onready var timer = $Timer
onready var voice_timer = $VoiceTimer
onready var transition = $Transition
onready var voice_audio_player = $VoiceAudioPlayer
onready var explosion_audio_player = $ExplosionAudioPlayer

func _ready():
	transition.fadein()
	explosion_audio_player.play()

func _on_Timer_timeout():
	transition.fadeout()

func _on_Transition_fadein_finished(_transition_name):
	timer.start()
	voice_timer.start()

func _on_Transition_fadeout_finished(_transition_name):
	visible = false
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(ResourceLoader.Intro)

func _on_VoiceTimer_timeout():
	voice_audio_player.play()

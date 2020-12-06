extends Node2D

onready var audio_stream_player = $AudioStreamPlayer
onready var animation_player = $AnimationPlayer
onready var timer = $Timer

func _on_AnimationPlayer_animation_finished(_anim_name):
	audio_stream_player.play()
	timer.start()
	
func _on_AnimationPlayer_last_animation_finished(_anim_name):
	# warning-ignore:return_value_discarded
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")

func _on_Timer_timeout():
	animation_player.disconnect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	animation_player.connect("animation_finished", self, "_on_AnimationPlayer_last_animation_finished")
	animation_player.play_backwards("enter")
	

extends Node2D

onready var label = $Label
onready var transition = $CircleTransition
onready var love4retro = $Love4Retro
onready var animation_player = $AnimationPlayer
onready var voice_player = $VoicePlayer

var finished = false

func _ready():
	transition.fadein()

func _input(event):
	if finished == true and not transition.running \
			and ((event is InputEventKey and event.pressed) or event is InputEventMouseButton):
		transition.fadeout()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "animate":
		animation_player.play("end")
	if anim_name == "end":
		animation_player.play("press")

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "press":
		voice_player.play()
		love4retro.visible = true
		finished = true

func _on_CircleTransition_fadeout_finished(transition_name):
	visible = false
	GameState.remove()
	get_tree().change_scene_to(ResourceLoader.Intro)
	

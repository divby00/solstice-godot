extends CanvasLayer

onready var label = $Label
onready var texture = $TextureRect
onready var animation_player = $AnimationPlayer
onready var transition = $CircleTransition

var game_paused = false setget set_game_paused
var press = 0.0

func _process(delta):
	if game_paused:
		if press < .8:
			press += delta
		if press >= .8 and Input.is_action_pressed("secondary") and not transition.running:
			back_to_menu()

func _input(_event):
	if Input.is_action_just_pressed("ui_cancel"):
		self.game_paused = !self.game_paused

func set_game_paused(value):
	game_paused = value
	if game_paused:
		get_tree().paused = game_paused
		animation_player.play("pause_on")
	else:
		animation_player.play("pause_off")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "pause_off":
		get_tree().paused = game_paused

func back_to_menu():
	label.visible = false
	texture.visible = false
	transition.fadeout()

func _on_CircleTransition_fadeout_finished(transition_name):
	get_tree().paused = false
	get_tree().change_scene("res://scenes/Intro/Intro.tscn")
	

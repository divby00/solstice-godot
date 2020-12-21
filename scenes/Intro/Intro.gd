extends Node2D

const BlueStarEffect = preload("res://scenes/Effects/BlueStarEffect.tscn")

onready var timer: Timer = $Timer
onready var credits_timer: Timer = $CreditsTimer
onready var transition_timer: Timer = $TransitionTimer
onready var camera: Camera2D = $Camera2D
onready var polygon: Polygon2D = $Polygon2D
onready var title_sprite: Sprite = $TitleSprite
onready var credits_tween: Tween = $CreditsTween
onready var label_skip: Label = $CanvasLayer/LabelSkip
onready var fade_transition = $FadeTransition
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var label: Label = $CanvasLayer/CenterContainer/VBoxContainer/Label

var status = Status.SCROLLING

enum Status {
	SCROLLING,
	TITLE_APPEARING,
	IDLE,
	IN_MENU,
}

var credits = [
	"2020 Love4Retro games",
	"Solstice is an Equinox remake",
	"Program and graphics by:",
	"Divby0",
	"Music by:",
	"Drozerix",
	"This is free software",
	"We hope you enjoy it!",
	"Thank you Raffaele Cecco!",
]

var messages = [
	"In the near future...",
	"...the world's most powerful\nnuclear plant is going\nto blow!!!"
]

var credits_index = 0
var tween_steps = 0
var primary_press: float = 0
var secondary_press: float = 0

func _ready():
	label.text = messages[0]
	for _i in range(100):
		create_star(Vector2(rand_range(0, 500), rand_range(0, 192)))
	fade_transition.fadein()

func skip_scrolling():
	animation_player.stop()
	status = Status.TITLE_APPEARING
	animation_player.play("title")
	camera.position.x = 324
	timer.stop()
	label.text = ""
	label_skip.text = ""

func start_menu():
	label_skip.rect_position = Vector2(0, 192)
	label.text = "PRIMARY BUTTON TO START\n\nSECONDARY BUTTON TO QUIT"
	label.align = HALIGN_CENTER
	start_tween()

func _input(event):
	if (event is InputEventKey and event.pressed) or event is InputEventMouseButton:
		if status == Status.SCROLLING:
			skip_scrolling()
		if status == Status.IDLE:
			status = Status.IN_MENU
			label_skip.text = ""
			label_skip.rect_position = Vector2(0, 192)
			start_menu()

func _process(delta):
	if status == Status.IN_MENU:
		if primary_press >= .5 and Input.is_action_pressed("primary"):
			start_game()
		elif primary_press < .5:
			primary_press += delta
		if secondary_press >= .5 and Input.is_action_pressed("secondary"):
			quit_game()
		elif secondary_press < .5:
			secondary_press += delta

func create_star(star_position):
	if Geometry.is_point_in_polygon(star_position, polygon.polygon):
		var blue_star_effect = BlueStarEffect.instance()
		blue_star_effect.global_position = star_position
		polygon.add_child(blue_star_effect)

func _on_Timer_timeout():
	label.text = messages[1]

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "scroll": # Camera stops moving
		skip_scrolling()
	if anim_name == "title": # Title has appeared, waiting for keypress
		status = Status.IDLE
		label_skip.text = "- PRESS ANY BUTTON -"

func start_tween():
	tween_steps = 0
	label_skip.rect_position.y = 192
	label_skip.text = credits[credits_index]
	credits_tween.interpolate_property(label_skip, "rect_position", Vector2(0, 192), Vector2(0, 152), 2.0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	credits_tween.start()

func _on_CreditsTween_tween_step(_object, _key, _elapsed, _value):
	tween_steps += 1
	if tween_steps == 70:
		label_skip.rect_position.y = 168
		credits_tween.stop(label_skip, "rect_position")
		credits_timer.start()

func _on_CreditsTween_tween_all_completed():
	credits_index += 1
	if credits_index >= credits.size():
		credits_index = 0
	start_tween()

func start_game():
	transition_timer.start()
	fade_transition.fadeout()

func quit_game():
	fade_transition.fadeout()
	get_tree().quit()

func _on_TransitionTimer_timeout():
	get_tree().change_scene("res://scenes/World/World.tscn")

func _on_CreditsTimer_timeout():
	credits_tween.resume(label_skip, "rect_position")

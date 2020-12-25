extends Node2D

const BlueStarEffect = preload("res://scenes/Effects/BlueStarEffect.tscn")

onready var timer: Timer = $Timer
onready var credits_timer: Timer = $CreditsTimer
onready var camera: Camera2D = $Camera2D
onready var polygon: Polygon2D = $Polygon2D
onready var title_sprite: Sprite = $TitleSprite
onready var credits_tween: Tween = $CreditsTween
onready var label_skip: Label = $CanvasLayer/LabelSkip
onready var transition = $CircleTransition
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var label: Label = $CanvasLayer/CenterContainer/VBoxContainer/Label
onready var main_menu = $MainMenu/NinePatchRect
onready var options_menu = $OptionsMenu/NinePatchRect

var status = Status.SCROLLING
var message_index = 0

enum Status {
	SCROLLING,
	TITLE_APPEARING,
	IDLE,
	IN_MENU,
	WORKING,
}

var credits = [
	"2020 Love4Retro games",
	"Solstice is an Equinox remake",
	"Program and graphics by:",
	"Jesus Chicharro 'Divby0'",
	"Music by:",
	"Nick Monson 'Drozerix'",
	"This is free software",
	"We hope you enjoy it!",
	"Thank you Raffaele Cecco!",
]

var messages = [
	"In the near future...",
	"...unknow entities have taken\nover the most powerful nuclear\npower plant in the world!",
	"The threat of a nuclear winter\nis bigger than ever..."
]

var credits_index = 0
var tween_steps = 0

func _ready():
	label.text = messages[message_index]
	for _i in range(100):
		create_star(Vector2(rand_range(0, 500), rand_range(0, 192)))
	transition.fadein()

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
	label.visible = false
	start_tween()
	main_menu.visible = true

func _input(event):
	if (event is InputEventKey and event.pressed) or event is InputEventMouseButton:
		if status == Status.SCROLLING:
			skip_scrolling()
		if status == Status.IDLE:
			status = Status.IN_MENU
			label_skip.text = ""
			label_skip.rect_position = Vector2(0, 192)
			start_menu()

func create_star(star_position):
	if Geometry.is_point_in_polygon(star_position, polygon.polygon):
		var blue_star_effect = BlueStarEffect.instance()
		blue_star_effect.global_position = star_position
		polygon.add_child(blue_star_effect)

func _on_Timer_timeout():
	message_index += 1
	label.text = messages[message_index]

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
	transition.fadeout("start")

func quit_game():
	transition.fadeout("quit")

func _on_CreditsTimer_timeout():
	credits_tween.resume(label_skip, "rect_position")

func _on_CircleTransition_fadeout_finished(transition_name):
	if transition_name == "start":
		visible = false
		get_tree().change_scene("res://scenes/World/World.tscn")
	else:
		label.visible = false
		label_skip.visible = false
		main_menu.visible = false
		visible = false
		get_tree().quit()

func _on_MainMenu_button_pressed(button_name):
	if button_name == "start":
		start_game()
	elif button_name == "options":
		start_options()
	elif button_name == "instructions":
		pass
	elif button_name == "quit":
		quit_game()
	
func start_options():
	main_menu.visible = !main_menu.visible
	options_menu.visible = !options_menu.visible

func _on_OptionsMenu_return_to_main_menu():
	main_menu.visible = !main_menu.visible
	options_menu.visible = !options_menu.visible

func _on_OptionsMenu_fullscreen_toggled(button_pressed):
	Configuration.fullscreen = button_pressed

func _on_OptionsMenu_music_volume_changed(volume):
	Configuration.music_volume = volume

func _on_OptionsMenu_sound_volume_changed(volume):
	#SoundFx.play("blip")
	Configuration.sfx_volume = volume

extends Node2D

const BlueStar = preload("res://scenes/Effects/BlueStar/BlueStar.tscn")

onready var help = $Help
onready var timer: Timer = $Timer
onready var transition = $Transition
onready var camera: Camera2D = $Camera2D
onready var polygon: Polygon2D = $Polygon2D
onready var main_menu = $MainMenu/NinePatchRect
onready var title_sprite: Sprite = $TitleSprite
onready var credits_tween: Tween = $CreditsTween
onready var credits_timer: Timer = $CreditsTimer
onready var options_menu = $OptionsMenu/NinePatchRect
onready var label_skip: Label = $CanvasLayer/LabelSkip
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var label: Label = $CanvasLayer/CenterContainer/VBoxContainer/Label

enum Status {
	SCROLLING,
	TITLE_APPEARING,
	IDLE,
	IN_MENU,
	WORKING,
}

var tween_steps = 0
var credits_index = 0
var message_index = 0
var credit_has_displayed = false
var status = Status.SCROLLING

var credits = [
	"2021 Love4Retro games",
	"Solstice is an Equinox remake",
	"Program and graphics by:",
	"Jesus Chicharro",
	"Music by:",
	"Nick Monson 'Drozerix'",
	"Help and support by:",
	"Miguel Angel Jimenez",
	"This is free software",
	"We hope you enjoy it!",
	"Thank you Raffaele Cecco!",
]

var messages = [
	"In the near future...",
	"...unknow entities have taken\nover the most powerful nuclear\nmining complex in the world!",
	"The threat of a nuclear winter\nis bigger than ever..."
]

func _ready():
	reset_music()
	help.help_is_posible = false
	label.text = messages[message_index]
	for _i in range(100):
		create_star(Vector2(rand_range(0, 500), rand_range(0, 192)))
	transition.fadein()

func _exit_tree():
	var stars = get_tree().get_nodes_in_group("BlueStarGroup")
	for star in stars:
		star.queue_free()

func reset_music():
	AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db2linear(0))

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
			call_deferred("start_menu")

func create_star(star_position):
	if Geometry.is_point_in_polygon(star_position, polygon.polygon):
		var blue_star = BlueStar.instance()
		blue_star.global_position = star_position
		polygon.add_child(blue_star)

func _on_Timer_timeout():
	message_index += 1
	label.text = messages[message_index]

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "scroll": # Camera stops moving
		skip_scrolling()
	if anim_name == "title": # Title has appeared, waiting for keypress
		status = Status.IDLE
		label_skip.text = "PRESS BUTTON - F1 FOR HELP"

func start_tween():
	tween_steps = 0
	label_skip.rect_position.y = 192
	label_skip.text = credits[credits_index]
# warning-ignore:return_value_discarded
	credits_tween.interpolate_property(label_skip, "rect_position", Vector2(0, 192), Vector2(0, 152), 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
# warning-ignore:return_value_discarded
	credits_tween.start()
	credit_has_displayed = false

func _on_CreditsTween_tween_step(_object, _key, _elapsed, _value):
	tween_steps += 1
	if int(_value[1]) == 168 and not credit_has_displayed:
		label_skip.rect_position.y = 168
# warning-ignore:return_value_discarded
		credits_tween.stop(label_skip, "rect_position")
		credits_timer.start()

func _on_CreditsTween_tween_all_completed():
	credits_index += 1
	if credits_index >= credits.size():
		credits_index = 0
	start_tween()

func start_game():
	GameState.loading = false
	transition.fadeout("start")

func quit_game():
	transition.fadeout("quit")

func _on_CreditsTimer_timeout():
# warning-ignore:return_value_discarded
	credit_has_displayed = true
	credits_tween.resume(label_skip, "rect_position")

func _on_Transition_fadein_finished(_transition_name):
	help.help_is_posible = true

func _on_Transition_fadeout_finished(transition_name):
	visible = false
	if transition_name == "start" or transition_name == "continue":
# warning-ignore:return_value_discarded
		get_tree().change_scene_to(ResourceLoader.WorldScene)
	else:
		label.visible = false
		label_skip.visible = false
		main_menu.visible = false
		get_tree().quit()

func _on_MainMenu_button_pressed(button_name):
	if button_name == "start":
		start_game()
	elif button_name == "continue":
		continue_game()
	elif button_name == "options":
		start_options()
	elif button_name == "quit":
		quit_game()

func continue_game():
	GameState.loading = true
	transition.fadeout("continue")
	
func start_options():
	main_menu.visible = false
	options_menu.visible = true

func _on_OptionsMenu_return_to_main_menu():
	main_menu.visible = true
	options_menu.visible = false

func _on_OptionsMenu_fullscreen_toggled(button_pressed):
	Configuration.fullscreen = button_pressed

func _on_OptionsMenu_music_volume_changed(volume):
	Configuration.music_volume = volume

func _on_OptionsMenu_sound_volume_changed(volume):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(volume))
	if options_menu != null and options_menu.visible:
		SoundFx.play("blip")
	Configuration.sfx_volume = volume

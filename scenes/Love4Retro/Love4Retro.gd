extends Node2D

onready var timer = $Timer
onready var transition = $Transition

const VERSION = "1.0.0"
const Cursor = preload("res://resources/textures/cursor.png")

func _ready():
	print("Solstice " + VERSION + " is running...")
	Configuration.load_and_save_config()
	transition.fadein()

func _on_Transition_fadein_finished(_transition_name):
	SoundFx.play("love4retro")
	timer.start()

func _on_Transition_fadeout_finished(_transition_name):
	visible = false
# warning-ignore:return_value_discarded
	get_tree().change_scene_to(ResourceLoader.Intro)

func _on_Timer_timeout():
	transition.fadeout()

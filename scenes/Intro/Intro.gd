extends Node2D

const BlueStarEffect = preload("res://scenes/Effects/BlueStarEffect.tscn")

onready var timer = $Timer
onready var camera = $Camera2D
onready var label = $CanvasLayer/CenterContainer/VBoxContainer/Label
onready var label_skip = $CanvasLayer/LabelSkip
onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var title_sprite = $TitleSprite
onready var polygon = $Polygon2D

var messages = [
	"In the near future...",
	"...the world's most powerful\nnuclear plant is going\nto blow!!!"
]

func _ready():
	label.text = messages[0]
	for _i in range(100):
		var star_position = Vector2(rand_range(0, 500), rand_range(0, 192))
		if Geometry.is_point_in_polygon(star_position, polygon.polygon):
			var blue_star_effect = BlueStarEffect.instance()
			blue_star_effect.global_position = star_position
			polygon.add_child(blue_star_effect)

func _process(_delta):
	if Input.is_action_just_pressed("secondary") and animation_player.is_playing():
		animation_player.stop()
		animation_player.play("title")
		camera.position.x = 324
		timer.stop()
		label.text = ""
		label_skip.text = "PRESS ENTER TO START"
		
	if Input.is_action_just_pressed("secondary") and not animation_player.is_playing():
		# warning-ignore:return_value_discarded
		get_tree().change_scene("res://scenes/World/World.tscn")

func _on_Timer_timeout():
	label.text = messages[1]

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "scroll":
		label.text = ""
		label_skip.text = "PRESS ENTER TO START"
		title_sprite.visible = true
		animation_player.play("title")

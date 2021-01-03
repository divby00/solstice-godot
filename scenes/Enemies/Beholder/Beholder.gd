extends "res://scenes/Enemies/Enemy.gd"

onready var awake_timer = $AwakeTimer
onready var sleep_timer = $SleepTimer
onready var animation_player = $AnimationPlayer

func _ready():
	awake_timer.wait_time = rand_range(2, 5)
	sleep_timer.wait_time = rand_range(2, 5)
	sleep_timer.start()

func fire():
	if in_screen:
		.create_bullet(Vector2.ONE, 18, 360, 18)

func _on_AwakeTimer_timeout():
	animation_player.play("close")
	sleep_timer.start()

func _on_SleepTimer_timeout():
	animation_player.play("open")
	awake_timer.start()

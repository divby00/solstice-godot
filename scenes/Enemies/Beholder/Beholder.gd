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

func on_enemy_died():
	var explosion = BigExplosion.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	explosion.global_position.y -= 32
	explosion.emitting = true
	emit_signal("enemy_died", self)
	for _i in range(7):
		.create_powerup(Vector2(rand_range(-8, +8), rand_range(-32, -24)))
	queue_free()

func _on_AwakeTimer_timeout():
	animation_player.play("close")
	sleep_timer.start()

func _on_SleepTimer_timeout():
	animation_player.play("open")
	awake_timer.start()

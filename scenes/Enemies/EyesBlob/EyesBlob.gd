extends "res://scenes/Enemies/Enemy.gd"

onready var animation_player = $AnimationPlayer

func _ready():
	start_animation()

func start_animation():
	var value = randi() % 2
	if value == 0:
		animation_player.play("idle")
	else:
		animation_player.play_backwards("idle")

func on_enemy_died():
	var explosion = BigExplosion.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	explosion.emitting = true
	emit_signal("enemy_died", self)
	.create_bullet(Vector2.ONE, 22.5, 360, 22.5)
	for _i in range(3):
		.create_powerup(Vector2(rand_range(-4, 4), rand_range(-4, 4)))
	queue_free()

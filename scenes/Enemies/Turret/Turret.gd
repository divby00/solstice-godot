extends "res://scenes/Enemies/Enemy.gd"

func fire():
	if in_screen:
		bullet_position.global_position.x -= 20
		.create_bullet(Vector2.LEFT, 1, 1, 1)
		bullet_position.global_position.x += 40
		.create_bullet(Vector2.RIGHT, 1, 1, 1)

func on_enemy_died():
	.create_big_explosion()
	for _i in range(3):
		.create_powerup(Vector2(rand_range(-8, 8), rand_range(-8, 8)))
	queue_free()

extends "res://scenes/Enemies/Enemy.gd"

func fire():
	if in_screen:
		bullet_position.global_position.x -= 20
		.create_bullet(Vector2.LEFT, 1, 1, 1)
		bullet_position.global_position.x += 40
		.create_bullet(Vector2.RIGHT, 1, 1, 1)

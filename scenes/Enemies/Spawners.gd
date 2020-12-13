extends Node2D

export(int) var MAX_ENEMIES = 50
var enemies = 0 setget set_enemies
var can_spawn = true

func on_enemy_appeared(enemy):
	self.enemies += 1

func on_enemy_died(enemy):
	self.enemies -= 1
	enemy.queue_free()

func set_enemies(value):
	enemies = clamp(value, 0, MAX_ENEMIES)
	print(enemies)
	can_spawn = enemies != MAX_ENEMIES

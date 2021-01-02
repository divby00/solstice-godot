extends Area2D

signal enemy_died
signal enemy_hurt

const MAX_HEALTH = 5

export(int) var health = MAX_HEALTH setget set_health

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		emit_signal("enemy_died")
	else:
		emit_signal("enemy_hurt")

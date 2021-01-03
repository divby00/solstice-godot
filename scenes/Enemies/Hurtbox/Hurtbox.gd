extends Area2D

signal enemy_died
signal enemy_hurt

const MAX_HEALTH = 500

export(int) var health = 5 setget set_health

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		emit_signal("enemy_died")
	elif health > 0 and health < 100:
		emit_signal("enemy_hurt")
	else:
		health = MAX_HEALTH
		emit_signal("enemy_hurt")

extends Node

export(int) var MAX_LIVES = 3
export(int) var MAX_HEALTH = 100

signal game_over
signal player_destroyed
signal health_changed(health)
signal lives_changed(lives)

var health = MAX_HEALTH setget set_health
var lives = MAX_LIVES setget set_lives
var selected_item = null
var invincible = false

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		emit_signal("player_destroyed")
		self.lives -= 1
		health = MAX_HEALTH
	else:
		emit_signal("health_changed", health)
	
func set_lives(value):
	lives = clamp(value, 0, MAX_LIVES)
	if lives == 0:
		emit_signal("game_over")
	else:
		emit_signal("lives_changed", lives)

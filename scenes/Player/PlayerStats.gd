extends Resource

class_name PlayerStats

export(int) var MAX_LIVES = 3
export(int) var MAX_HEALTH = 100
export(int) var MAX_LASER = 100
export(int) var MAX_THRUST = 100

var health = MAX_HEALTH setget set_health
var laser = MAX_LASER setget set_laser
var thrust = MAX_THRUST setget set_thrust
var lives = MAX_LIVES setget set_lives
var selected_item = null
var item = null

signal player_health_changed(health)
signal player_laser_changed(laser)
signal player_thrust_changed(thrust)
signal player_lives_changed(lives)

signal player_destroyed

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		emit_signal("player_destroyed")
	emit_signal("player_health_changed", health)
	
func set_laser(value):
	if value < laser:
		laser = clamp(value, 0, MAX_LASER)
	emit_signal("player_laser_changed", laser)

func set_thrust(value):
	if value < thrust:
		thrust = clamp(value, 0, MAX_THRUST)
	emit_signal("player_thrust_changed", thrust)

func set_lives(value):
	if value < lives:
		lives = clamp(value, 0, MAX_LIVES)
	emit_signal("player_lives_changed", lives)
	

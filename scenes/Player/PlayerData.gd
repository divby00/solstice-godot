extends Node

export(int) var MAX_LIVES = 3
export(int) var MAX_HEALTH = 112
export(int) var MAX_THRUST = 112
export(int) var MAX_LASER = 112
export(int) var MAX_TIME = 112

signal game_over
signal player_destroyed
signal health_changed(health)
signal lives_changed(lives)
signal thrust_changed(thrust)
signal laser_changed(laser)
signal time_changed(time)
signal status_changed(old_status, new_status)

enum Status {
	OK,
	DAMAGED,
	DESTROYED,
	INVINCIBLE,
	TELEPORT
}

var health = MAX_HEALTH setget set_health
var lives = MAX_LIVES setget set_lives
var thrust = MAX_THRUST setget set_thrust
var laser = MAX_LASER setget set_laser
var time = MAX_TIME setget set_time
var selected_item = null
var status = Status.OK setget set_status
var invincible = false
var in_teleporter = false

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		emit_signal("player_destroyed")
	else:
		emit_signal("health_changed", health)
	
func set_lives(value):
	lives = clamp(value, 0, MAX_LIVES)
	if lives == 0:
		emit_signal("lives_changed", lives)
		emit_signal("game_over")
	else:
		emit_signal("lives_changed", lives)

func set_thrust(value):
	thrust = clamp(value, 5, MAX_THRUST)
	emit_signal("thrust_changed", thrust)

func set_laser(value):
	laser = clamp(value, 5, MAX_LASER)
	emit_signal("laser_changed", laser)

func set_time(value):
	time = clamp(value, 5, MAX_TIME)
	emit_signal("time_changed", time)

func set_status(value):
	var old_status = self.status
	var new_status = value
	status = value
	invincible = status == Status.INVINCIBLE
	in_teleporter = status == Status.TELEPORT
	emit_signal("status_changed", old_status, new_status)

extends Node

signal game_over
signal player_destroyed
signal health_changed(health)
signal plasma_changed(plasma)
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

export(int) var LIVES = 3
export(int) var MAX_LIVES = 9
export(int) var MAX_HEALTH = 112
export(int) var MAX_THRUST = 112
export(int) var MAX_LASER = 112
export(int) var MAX_TIME = 112
export(int) var MAX_PLASMA = 17

var invincible = false
var selected_item = null
var lives = LIVES setget set_lives
var time = MAX_TIME setget set_time
var laser = MAX_LASER setget set_laser
var status = Status.OK setget set_status
var health = MAX_HEALTH setget set_health
var thrust = MAX_THRUST setget set_thrust
var plasma = 0 setget set_plasma

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health == 0:
		health = MAX_HEALTH
		emit_signal("player_destroyed")
	else:
		emit_signal("health_changed", health)
	
func set_lives(value):
	lives = clamp(value, 0, MAX_LIVES)
	if lives == 0:
		emit_signal("game_over")
	else:
		emit_signal("lives_changed", lives)

func set_plasma(value):
	plasma = clamp(value, 0, MAX_PLASMA)
	emit_signal("plasma_changed", plasma)

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
	emit_signal("status_changed", old_status, new_status)

func reset():
	health = MAX_HEALTH
	lives = LIVES
	thrust = MAX_THRUST
	laser = MAX_LASER
	time = MAX_TIME
	plasma = 0
	selected_item = null
	status = Status.OK
	invincible = false

func reset_between_levels():
	health = MAX_HEALTH
	thrust = MAX_THRUST
	laser = MAX_LASER
	time = MAX_TIME
	plasma = 0
	selected_item = null
	status = Status.OK
	invincible = false

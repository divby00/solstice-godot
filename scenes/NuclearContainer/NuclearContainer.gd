extends Node2D

signal time_tick_finished(seconds_to_explosion, time_left)
signal nuclear_waste_stored(storage)
signal explosion_triggered

export(int) var seconds_to_explosion = 30

onready var audio_player = $AudioStreamPlayer2D
onready var explosion_timer = $ExplosionTimer
var player_in_nuclear_storage = false
var time_left = 0

func _ready():
	time_left = seconds_to_explosion

func _process(delta):
	if player_in_nuclear_storage and Input.is_action_just_pressed("ui_accept") and PlayerData.selected_item == "nuclearwaste":
		explosion_timer.stop()
		audio_player.play()
		emit_signal("nuclear_waste_stored", self)

func _on_ActivateArea_body_entered(body):
	player_in_nuclear_storage = true

func _on_ActivateArea_body_exited(body):
	player_in_nuclear_storage = false

func _on_ExplosionTimer_timeout():
	time_left -= 1
	emit_signal("time_tick_finished", seconds_to_explosion, time_left)
	if time_left == 0:
		emit_signal("explosion_triggered")

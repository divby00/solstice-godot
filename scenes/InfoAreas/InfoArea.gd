extends Area2D

signal info_area_entered(info_area)

onready var timer = $Timer

export(String) var text = ""
var player_into_info_area = false
var can_emit = true

func _process(delta):
	if player_into_info_area and can_emit:
		emit_signal("info_area_entered", self)
		can_emit = false
		timer.start()

func _on_InfoArea_body_entered(body):
	player_into_info_area = true

func _on_InfoArea_body_exited(body):
	player_into_info_area = false

func _on_Timer_timeout():
	can_emit = true

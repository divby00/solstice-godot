extends StaticBody2D

signal elevator_activated(level_pass)
const items = ["pass02", "pass03", "pass04", "pass05", "pass06", "pass07", "pass08"]

onready var activate_area: Area2D = $ActivateArea

var player_in_elevator = false

func _process(delta):
	if player_in_elevator and Input.is_action_just_pressed("secondary"):
		emit_signal("elevator_activated", PlayerData.selected_item)

func _on_ActivateArea_body_entered(body):
	if items.has(PlayerData.selected_item):
		player_in_elevator = true

func _on_ActivateArea_body_exited(body):
	player_in_elevator = false

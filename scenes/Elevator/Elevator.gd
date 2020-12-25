extends StaticBody2D

signal elevator_activated(level_pass)
const items = ["pass02", "pass03", "pass04", "pass05", "pass06", "pass07", "pass08"]

onready var activate_area: Area2D = $ActivateArea

var elevator_usable = false
var player_in_elevator = false

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		print(elevator_usable)
	if player_in_elevator and Input.is_action_just_pressed("secondary") and elevator_usable:
		emit_signal("elevator_activated", PlayerData.selected_item)

func _on_ActivateArea_body_entered(_body):
	if items.has(PlayerData.selected_item):
		player_in_elevator = true

func _on_ActivateArea_body_exited(_body):
	player_in_elevator = false

func on_nuclear_waste_stored(_storage):
	elevator_usable = true

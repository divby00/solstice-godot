extends StaticBody2D

signal nuclear_waste_stored(storage)

onready var audio_player = $AudioStreamPlayer2D

var player_stats = ResourceLoader.player_stats
var player_in_nuclear_storage = false

func _process(delta):
	if player_in_nuclear_storage and Input.is_action_just_pressed("ui_accept") and player_stats.selected_item == "nuclearwaste":
		audio_player.play()
		emit_signal("nuclear_waste_stored", self)

func _on_ActivateArea_body_entered(body):
	player_in_nuclear_storage = true

func _on_ActivateArea_body_exited(body):
	player_in_nuclear_storage = false

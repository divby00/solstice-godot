extends Area2D

signal player_collided(damage)

export(float) var damage = 2.0

var player_collision = false

func _process(_delta):
	if player_collision:
		emit_signal("player_collided", damage)

func _on_Hitbox_body_entered(_body):
	player_collision = true

func _on_Hitbox_body_exited(_body):
	player_collision = false

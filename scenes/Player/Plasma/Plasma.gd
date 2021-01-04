extends Area2D

signal enemy_damaged(body, damage)

func _on_Plasma_body_entered(body):
	if body != null and body.is_in_group("EnemyGroup"):
		if body.hurtbox != null:
			body.hurtbox.health -= 2

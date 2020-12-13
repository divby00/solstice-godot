extends Area2D

class_name Enemy

signal enemy_attacked(enemy)
signal enemy_attack_stopped(enemy)

export(float) var damage = .5

var attacking = false

func _process(delta):
	if attacking and PlayerData.status != PlayerData.Status.INVINCIBLE:
		PlayerData.health -= damage
		emit_signal("enemy_attacked", self)
	else:
		emit_signal("enemy_attack_stopped", self)

func _on_Hitbox_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		attacking = true

func _on_Hitbox_body_exited(body):
	if body.is_in_group("PlayerGroup"):
		attacking = false

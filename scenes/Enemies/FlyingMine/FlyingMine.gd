extends Area2D

signal enemy_attacked(strength)

const BigExplosion = preload("res://scenes/Effects/BigExplosion/BigExplosion.tscn")

export(int) var energy = 15

var angle = 0

func _enter_tree():
	Utils.connect_signal(self, "enemy_attacked", ResourceLoader.player, "on_enemy_attacked")

func _process(delta):
	angle += delta * 5
	global_position.x += sin(angle) / 3
	global_position.y += cos(angle) / 3

func explode():
	SoundFx.play("explosion", 1.0 + rand_range(-0.2, 0.2))
	var explosion = BigExplosion.instance()
	explosion.global_position = global_position
	explosion.emitting = true
	explosion.z_index = 2
	get_tree().current_scene.add_child(explosion)

func _on_FlyingMine_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		explode()
		emit_signal("enemy_attacked", energy)
		queue_free()

func _on_Timer_timeout():
	explode()
	queue_free()

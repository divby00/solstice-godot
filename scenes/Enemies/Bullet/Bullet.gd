extends Area2D

signal enemy_attacked(strength)

const GreenExplosion = preload("res://scenes/Effects/GreenExplosion/GreenExplosion.tscn")

export(int) var speed = 125
export(int) var energy = 10
var direction = Vector2.ZERO

func _enter_tree():
	Utils.connect_signal(self, "enemy_attacked", ResourceLoader.player, "on_enemy_attacked")

func _process(_delta):
	global_position += direction * _delta * speed

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		explode()
		emit_signal("enemy_attacked", energy)
		queue_free()
	else:
		explode()
		queue_free()

func explode():
	SoundFx.play("explosion")
	var explosion = GreenExplosion.instance()
	explosion.global_position = global_position
	explosion.z_index = 2
	get_tree().current_scene.add_child(explosion)

extends KinematicBody2D

signal enemy_died(enemy)
signal enemy_attacked(damage)

const Bullet = preload("res://scenes/Enemies/Bullet.tscn")
const BigExplosion = preload("res://scenes/Effects/BigExplosionParticles.tscn")

export(float) var frequency = .3
export(int) var max_health = 10

onready var sprite = $Sprite
onready var cursor = $Position2D
onready var bullet_timer = $BulletTimer
onready var shader_timer = $ShaderTimer
onready var end_alert_timer = $EndAlertTimer
onready var animation_player = $AnimationPlayer

var direction = Vector2.ZERO
var health = max_health setget set_health

func _ready():
	bullet_timer.wait_time = frequency
	direction = (cursor.global_position - global_position).normalized()

func fire_bullet():
	var fire_type = randi() % 2
	if fire_type == 0:
		create_bullet(-40, 40, 20)
	else:
		create_bullet(-20, 20, 20)

func create_bullet(from, to, step):
	for i in range(from, to + 1, step):
		var bullet = Bullet.instance()
		bullet.global_position = cursor.global_position
		bullet.direction = direction.rotated(deg2rad(i + rand_range(-0, 0)))
		get_tree().current_scene.add_child(bullet)

func set_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		var explosion = BigExplosion.instance()
		explosion.global_position = global_position
		explosion.emitting = true
		get_tree().current_scene.add_child(explosion)
		queue_free()
		#emit_signal("enemy_died", self)
	else:
		SoundFx.play("enemy_hurt")
		bullet_timer.start()
		end_alert_timer.start()
		shader_timer.start()
		sprite.material.set_shader_param("active", true)

func _on_DetectionArea_body_entered(body):
	bullet_timer.start()

func _on_DetectionArea_body_exited(body):
	end_alert_timer.start()

func _on_BulletTimer_timeout():
	animation_player.play("fire")

func _on_EndAlertTimer_timeout():
	bullet_timer.stop()

func _on_ShaderTimer_timeout():
	sprite.material.set_shader_param("active", false)

func _on_AnimationPlayer_animation_finished(anim_name):
	animation_player.play("idle")

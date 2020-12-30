extends KinematicBody2D

signal enemy_died(enemy)
signal enemy_attacked(damage)

const Bullet = preload("res://scenes/Enemies/Bullet.tscn")
const BigExplosion = preload("res://scenes/Effects/BigExplosionParticles.tscn")

onready var sprite = $Sprite
onready var shader_timer = $ShaderTimer
onready var animation_player = $AnimationPlayer

export(int) var max_health = 2
var health = max_health setget set_health

func _ready():
	start_animation()

func start_animation():
	var value = randi() % 2
	if value == 0:
		animation_player.play("animate")
	else:
		animation_player.play_backwards("animate")

func set_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		var explosion = BigExplosion.instance()
		get_tree().current_scene.add_child(explosion)
		explosion.global_position = global_position
		explosion.global_position.y -= 12
		explosion.emitting = true
		create_bullet(22.5, 360, 22.5)
		emit_signal("enemy_died", self)
		queue_free()
	else:
		SoundFx.play("enemy_hurt")
		sprite.material.set_shader_param("active", true)
		shader_timer.start()

func create_bullet(from, to, step):
	for i in range(from, to + 1, step):
		var bullet = Bullet.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = global_position
		bullet.global_position.y -= 12
		bullet.direction = Vector2.ONE.rotated(deg2rad(i + rand_range(-0, 0)))

func _on_ShaderTimer_timeout():
	sprite.material.set_shader_param("active", false)

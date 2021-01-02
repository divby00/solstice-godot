extends KinematicBody2D

signal enemy_hurt
signal enemy_died
signal enemy_attacked(damage)

const Bullet = preload("res://scenes/Enemies/Bullet/Bullet.tscn")
const BigExplosion = preload("res://scenes/Effects/BigExplosion/BigExplosion.tscn")

onready var sprite = $Sprite
onready var hurtbox = $Hurtbox
onready var shader_timer = $ShaderTimer
onready var bullet_position = $BulletPosition

func _ready():
	set_process(false)
	set_physics_process(false)
	Utils.connect_signal(hurtbox, "enemy_hurt", self, "on_enemy_hurt")
	Utils.connect_signal(hurtbox, "enemy_died", self, "on_enemy_died")

func create_bullet(direction, from, to, step, energy=15):
	for i in range(from, to + 1, step):
		var bullet = Bullet.instance()
		get_tree().current_scene.add_child(bullet)
		bullet.energy = energy
		bullet.global_position = bullet_position.global_position
		bullet.direction = direction.rotated(deg2rad(i + rand_range(-0, 0)))

func on_enemy_hurt():
	SoundFx.play("enemy_hurt")
	sprite.material.set_shader_param("active", true)
	shader_timer.start()
	emit_signal("enemy_hurt")

func on_enemy_died():
	var explosion = BigExplosion.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	explosion.emitting = true
	emit_signal("enemy_died", self)
	queue_free()

func _on_ShaderTimer_timeout():
	sprite.material.set_shader_param("active", false)

func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	set_physics_process(true)

func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	set_physics_process(false)

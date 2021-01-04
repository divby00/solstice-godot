extends KinematicBody2D

signal enemy_hurt
signal enemy_died
signal enemy_attacked(damage)

const Bullet = preload("res://scenes/Enemies/Bullet/Bullet.tscn")
const BigExplosion = preload("res://scenes/Effects/BigExplosion/BigExplosion.tscn")
const PlasmaPowerup = preload("res://scenes/Enemies/PlasmaPowerup/PlasmaPowerup.tscn")
const GreenExplosion = preload("res://scenes/Effects/GreenExplosion/GreenExplosion.tscn")

onready var sprite = $Sprite
onready var hitbox = $Hitbox
onready var hurtbox = $Hurtbox
onready var shader_timer = $ShaderTimer
onready var bullet_position = $BulletPosition

var in_screen = false

func _ready():
	set_process(false)
	set_physics_process(false)
	Utils.connect_signal(hurtbox, "enemy_hurt", self, "on_enemy_hurt")
	Utils.connect_signal(hurtbox, "enemy_died", self, "on_enemy_died")
	Utils.connect_signal(hitbox, "player_collided", self, "on_player_collided")

func create_bullet(direction, from, to, step, energy=15):
	for i in range(from, to + 1, step):
		var bullet = Bullet.instance()
		get_tree().current_scene.call_deferred("add_child", bullet)
		bullet.energy = energy
		bullet.global_position = bullet_position.global_position
		bullet.direction = direction.rotated(deg2rad(i))

func create_big_explosion():
	create_explosion(BigExplosion.instance())

func create_green_explosion():
	create_explosion(GreenExplosion.instance())

func create_explosion(explosion):
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	SoundFx.play("explosion", 1.0 + rand_range(-0.2, 0.2))
	emit_signal("enemy_died", self)
	queue_free()

func create_powerup(optional_transform=Vector2.ZERO):
	var powerup = PlasmaPowerup.instance()
	get_tree().current_scene.call_deferred("add_child", powerup)
	powerup.global_position = global_position + optional_transform

func on_enemy_hurt():
	SoundFx.play("enemy_hurt")
	sprite.material.set_shader_param("active", true)
	shader_timer.start()
	emit_signal("enemy_hurt")

func on_enemy_died():
	create_big_explosion()
	create_powerup()
	queue_free()

func on_player_collided(damage):
	emit_signal("enemy_attacked", damage)

func _on_ShaderTimer_timeout():
	sprite.material.set_shader_param("active", false)

func _on_VisibilityNotifier2D_screen_entered():
	set_process(true)
	set_physics_process(true)
	in_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	set_process(false)
	set_physics_process(false)
	in_screen = false

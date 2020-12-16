extends KinematicBody2D

class_name Enemy

const GreenExplosionEffect = preload("res://scenes/Effects/GreenExplosionEffect.tscn")

signal enemy_died(enemy)
signal enemy_attacked(damage)

onready var sprite = $Sprite
onready var timer = $HurtTimer
onready var animation_player = $AnimationPlayer

export(int) var MAX_HEALTH = 1
export(int) var MAX_SPEED = 15
export(float) var damage = .5
onready var health = MAX_HEALTH setget set_health

var attacking = false
var motion = Vector2.ZERO
var status = Status.NORMAL
var chasing_player = false

enum Status {
	NORMAL,
	CHASING,
	HURT,
	SPAWN,
}

func _ready():
	set_physics_process(false)
	motion = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	animation_player.play("spawn")

func _process(delta):
	if attacking:
		emit_signal("enemy_attacked", damage)

func _on_Hitbox_body_entered(body):
	attacking = true

func _on_Hitbox_body_exited(body):
	attacking = false

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health <= 0:
		var explosion = GreenExplosionEffect.instance()
		explosion.global_position = global_position
		get_tree().current_scene.add_child(explosion)
		emit_signal("enemy_died", self)
	else:
		timer.start()
		status = Status.HURT
		animation_player.play("hurt")

func _on_Area2D_body_entered(body):
	chasing_player = true

func _on_Area2D_body_exited(body):
	chasing_player = false

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func _on_HurtTimer_timeout():
	status = Status.NORMAL
	animation_player.play("normal")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		animation_player.play("normal")

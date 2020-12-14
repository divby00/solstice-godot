extends KinematicBody2D

class_name Enemy

const GreenExplosionEffect = preload("res://scenes/Effects/GreenExplosionEffect.tscn")

signal enemy_died(enemy)
signal enemy_attacked(enemy)
signal enemy_attack_stopped(enemy)

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
	motion = Vector2(1, 1)
	animation_player.play("spawn")

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

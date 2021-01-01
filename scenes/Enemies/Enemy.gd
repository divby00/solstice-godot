extends KinematicBody2D

class_name Enemy

const GreenExplosion = preload("res://scenes/Effects/GreenExplosion/GreenExplosion.tscn")

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

func _process(_delta):
	chasing_player = global_position.distance_to(ResourceLoader.player.global_position) < 64
	if attacking:
		emit_signal("enemy_attacked", damage)

func _on_Hitbox_body_entered(_body):
	attacking = true

func _on_Hitbox_body_exited(_body):
	attacking = false

func set_health(value):
	health = clamp(value, 0, MAX_HEALTH)
	if health <= 0:
		var explosion = GreenExplosion.instance()
		explosion.global_position = position
		get_tree().current_scene.add_child(explosion)
		SoundFx.play("explosion")
		emit_signal("enemy_died", self)
	else:
		timer.start()
		status = Status.HURT
		SoundFx.play("enemy_hurt")
		animation_player.play("hurt")

func _on_VisibilityNotifier2D_screen_entered():
	set_physics_process(true)

func _on_HurtTimer_timeout():
	status = Status.NORMAL
	animation_player.play("normal")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		animation_player.play("normal")

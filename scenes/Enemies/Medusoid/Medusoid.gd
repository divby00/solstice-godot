extends "res://scenes/Enemies/Enemy.gd"

onready var animation_player = $AnimationPlayer

var motion = Vector2.ZERO
var chasing_player = false

func _ready():
	motion = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	animation_player.play("spawn")

func _process(_delta):
	chasing_player = global_position.distance_to(ResourceLoader.player.global_position) < 60

func _physics_process(_delta):
	if chasing_player:
		motion = Vector2(ResourceLoader.player.global_position - global_position).normalized() * 1.1
	var collision = move_and_collide(motion)
	if collision:
		if not chasing_player:
			motion = motion.bounce(collision.normal)

func on_enemy_died():
	.create_powerup()
	.create_green_explosion()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		animation_player.play("idle")

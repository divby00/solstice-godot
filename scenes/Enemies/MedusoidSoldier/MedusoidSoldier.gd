extends "res://scenes/Enemies/Enemy.gd"

const GreenExplosion = preload("res://scenes/Effects/GreenExplosion/GreenExplosion.tscn")

onready var raycast = $RayCast2D
onready var shoot_timer = $ShootTimer
onready var animation_player = $AnimationPlayer

var motion = Vector2.ZERO
var chasing_player = false

func _ready():
	motion = Vector2(rand_range(-1, 1), rand_range(-1, 1))
	animation_player.play("spawn")
	shoot_timer.wait_time = rand_range(0.5, 2.5)

func _process(_delta):
	chasing_player = global_position.distance_to(ResourceLoader.player.global_position) < 80

func _physics_process(_delta):
	if chasing_player:
		motion = Vector2(ResourceLoader.player.global_position - global_position).normalized() * 1.15
	var collision = move_and_collide(motion)
	if collision:
		if not chasing_player:
			motion = motion.bounce(collision.normal)
	raycast.cast_to = ResourceLoader.player.global_position - global_position

func on_enemy_died():
	var explosion = GreenExplosion.instance()
	get_tree().current_scene.add_child(explosion)
	explosion.global_position = global_position
	SoundFx.play("explosion", 1.0 + rand_range(-0.2, 0.2))
	emit_signal("enemy_died", self)
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "spawn":
		animation_player.play("idle")

func _on_ShootTimer_timeout():
	shoot_timer.wait_time = rand_range(0.5, 2.5)
	shoot_timer.start()
	if in_screen and raycast.is_colliding():
		var body = raycast.get_collider()
		if body.is_in_group("PlayerGroup"):
			.create_bullet((ResourceLoader.player.global_position - global_position).normalized(), 1, 1, 1)

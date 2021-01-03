extends "res://scenes/Enemies/Enemy.gd"

export(float) var shoot_frequency = .3

onready var bullet_timer = $BulletTimer
onready var end_alert_timer = $EndAlertTimer
onready var animation_player = $AnimationPlayer

var direction = Vector2.ZERO

func _ready():
	bullet_timer.wait_time = shoot_frequency
	direction = (bullet_position.global_position - global_position).normalized()

func fire():
	var fire_type = randi() % 2
	if fire_type == 0:
		.create_bullet(direction, -40, 40, 20)
	else:
		.create_bullet(direction, -15, 15, 10)

func on_enemy_hurt():
	SoundFx.play("enemy_hurt")
	sprite.material.set_shader_param("active", true)
	if bullet_timer.is_stopped():
		bullet_timer.start()
	end_alert_timer.start()
	shader_timer.start()
	emit_signal("enemy_hurt")

func _on_BulletTimer_timeout():
	animation_player.play("fire")

func _on_EndAlertTimer_timeout():
	bullet_timer.stop()

func _on_DetectionArea_body_entered(_body):
	bullet_timer.start()

func _on_DetectionArea_body_exited(_body):
	end_alert_timer.start()

func _on_AnimationPlayer_animation_finished(_anim_name):
	animation_player.play("idle")

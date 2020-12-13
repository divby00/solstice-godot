extends Node2D

const RedStarParticle = preload("res://scenes/Effects/RedStarParticle.tscn")
onready var raycast = $RayCast2D
onready var laser_texture = $LaserTexture
onready var detonation_sprite = $LaserDetonationSprite
onready var animation_player = $AnimationPlayer
onready var timer = $Timer
onready var recharge_timer = $RechargeTimer
onready var audio_player = $AudioStreamPlayer
onready var ray_position = $Position2D

var can_shoot = true

func fire():
	if can_shoot and PlayerData.laser > 5:
		PlayerData.laser -= .25
		audio_player.play()
		can_shoot = false
		animation_player.play("detonation")
		if raycast.is_colliding():
			var body = raycast.get_collider()
			print(body is Enemy)
			var point = raycast.get_collision_point()
			print(point.x)
			var ray_length = abs(point.x - ray_position.global_position.x)
			if ray_length > 7:
				laser_texture.rect_size.x = ray_length
			var particles = RedStarParticle.instance()
			particles.global_position = point
			particles.emitting = true
			get_tree().current_scene.add_child(particles)
		else:
			laser_texture.rect_size.x = 240
		laser_texture.visible = true
		timer.start()
		recharge_timer.start()

func _on_Timer_timeout():
	laser_texture.visible = false
	laser_texture.rect_size.x = 0

func _on_RechargeTimer_timeout():
	can_shoot = true

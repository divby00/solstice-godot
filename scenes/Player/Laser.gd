extends Node2D

const RedStarParticle = preload("res://scenes/Effects/RedStarParticle.tscn")
const GreenStarParticle = preload("res://scenes/Effects/GreenStarParticle.tscn")

onready var animation_player = $AnimationPlayer
onready var timer: Timer = $Timer
onready var recharge_timer: Timer = $RechargeTimer
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var raycast: RayCast2D = $RayCast2D
onready var detonation_sprite: Sprite = $LaserDetonationSprite
onready var ray_position: Position2D = $Position2D
onready var ray: Line2D = $Line2D

var can_shoot = true

func _process(_delta):
	var direction = (get_global_mouse_position() - global_position).normalized()
	rotation = direction.angle()

func fire():
	if can_shoot and PlayerData.laser > 5:
		can_shoot = false
		PlayerData.laser -= .25
		animation_player.play("detonation")
		audio_player.play()
		if raycast.is_colliding():
			var body = raycast.get_collider()
			var point = raycast.get_collision_point()
			ray.set_point_position(1, to_local(point))
			var particles = null
			#if body is Enemy:
			if body.is_in_group("EnemyGroup"):
				body.health -= 1
				particles = GreenStarParticle.instance()
			else:
				particles = RedStarParticle.instance()
			particles.global_position = point
			particles.emitting = true
			get_tree().current_scene.add_child(particles)
		else:
			ray.set_point_position(1, get_local_mouse_position() * 200)
		ray.visible = true
		timer.start()
		recharge_timer.start()

func _on_Timer_timeout():
	ray.visible = false

func _on_RechargeTimer_timeout():
	can_shoot = true

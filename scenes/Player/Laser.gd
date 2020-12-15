extends Node2D

const RedStarParticle = preload("res://scenes/Effects/RedStarParticle.tscn")

onready var cursor: Sprite = $Cursor
onready var animation_player = $AnimationPlayer
onready var timer: Timer = $Timer
onready var recharge_timer: Timer = $RechargeTimer
onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer
onready var raycast: RayCast2D = $RayCast2D
onready var detonation_sprite: Sprite = $LaserDetonationSprite
onready var ray_position: Position2D = $Position2D
onready var ray: Line2D = $Line2D

var can_shoot = true

func _process(delta):
	cursor.global_position = get_global_mouse_position()
	var direction = (cursor.global_position - global_position).normalized()
	rotation = direction.angle()
	cursor.rotation = -rotation

func fire():
	if can_shoot and PlayerData.laser > 5:
		can_shoot = false
		PlayerData.laser -= .25
		animation_player.play("detonation")
		audio_player.play()
		if raycast.is_colliding():
			var body = raycast.get_collider()
			if body is Enemy:
				body.health -= 1
			var point = raycast.get_collision_point()
			ray.set_point_position(1, to_local(point))
			var particles = RedStarParticle.instance()
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

extends "res://scenes/Enemies/Enemy.gd"

onready var timer = $Timer

export(int) var speed = 50
export(int) var powerup_threshold = 100

var motion = Vector2.ZERO
var direction = Vector2.UP

func _ready():
	get_direction()

func _process(delta):
	motion = direction * delta * speed
	var collision = move_and_collide(motion)
	if collision:
		get_direction()
		timer.stop()
		timer.start()
	
	var powerups = get_tree().get_nodes_in_group("PowerupGroup")
	for powup in powerups:
		if global_position.distance_to(powup.global_position) < powerup_threshold:
			var squid_vector = (global_position - powup.global_position).normalized()
			powup.global_position += squid_vector * 100 * delta

func get_direction():
	direction = Vector2(round(rand_range(-1, 1)), round(rand_range(-1, 1))).normalized()
	if direction == Vector2.ZERO:
		if ResourceLoader.player.global_position > global_position:
			direction = Vector2.RIGHT
		else:
			direction = Vector2.LEFT
	rotation = direction.angle()

func pick_and_shoot():
	SoundFx.play("squidpicks")
	hurtbox.health += 2
	.create_bullet(Vector2.UP, 0, 360, 45)

func _on_Timer_timeout():
	get_direction()

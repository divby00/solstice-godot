extends Enemy

func _physics_process(delta):
	if chasing_player:
		motion = Vector2(ResourceLoader.player.global_position - global_position).normalized() * 1.25
	var collision = move_and_collide(motion)
	if collision:
		if not chasing_player:
			motion = motion.bounce(collision.normal)

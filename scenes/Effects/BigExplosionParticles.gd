extends CPUParticles2D

export(bool) var remove_when_finish = false

func _on_Timer_timeout():
	if remove_when_finish:
		queue_free()

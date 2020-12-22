extends CPUParticles2D

onready var audio_player = $AudioStreamPlayer

export(bool) var remove_when_finish = false

func _ready():
	audio_player.play()

func _on_Timer_timeout():
	if remove_when_finish:
		queue_free()

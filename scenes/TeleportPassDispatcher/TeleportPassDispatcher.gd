extends StaticBody2D

signal pass_dispatched(dispatcher)

onready var particles = $CPUParticles2D
onready var spawner = $ItemSpawner

var player_on_dispatcher = false

func _process(delta):
	if player_on_dispatcher:
		PlayerData.health += .25
		if Input.is_action_just_pressed("down"):
			emit_signal("pass_dispatched", self)

func _on_ActivateArea_body_entered(body):
	player_on_dispatcher = true
	particles.emitting = true

func _on_ActivateArea_body_exited(body):
	player_on_dispatcher = false
	particles.emitting = false

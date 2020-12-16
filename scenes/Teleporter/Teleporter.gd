tool
extends StaticBody2D

class_name Teleporter

signal player_over_charger(teleporter)
signal teleporter_activated(teleporter)

export(String) var teleporter_name = ""
export(String) var linked_teleporter = ""

onready var label: Label = $Label
onready var particles: CPUParticles2D = $CPUParticles2D

var player_on_charger = false

func _ready():
	label.visible = Engine.is_editor_hint()
	label.text = "Name: " + teleporter_name + "\nLinked to: " + linked_teleporter

func _process(delta):
	if player_on_charger:
		emit_signal("player_over_charger", self)

func _on_ActivateArea_body_entered(body):
	if get_parent().charges > 0:
		SoundFx.play("teleport")
		particles.emitting = true
		emit_signal("teleporter_activated", self)

func _on_LoadingArea_body_entered(body):
	player_on_charger = true

func _on_LoadingArea_body_exited(body):
	player_on_charger = false

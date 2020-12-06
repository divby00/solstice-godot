tool
extends Area2D

onready var label = $Label

func _ready():
	label.visible = Engine.is_editor_hint()

func _on_MagneticArea_body_entered(body):
	if body.is_in_group("PlayerGroup"):
		body.is_in_magnetic_area = true

func _on_MagneticArea_body_exited(body):
	if body.is_in_group("PlayerGroup"):
		body.is_in_magnetic_area = false

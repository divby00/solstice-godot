extends Node2D

func _on_Area2D_body_entered(body):
	body.is_in_magnetic_area = true

func _on_Area2D_body_exited(body):
	body.is_in_magnetic_area = false

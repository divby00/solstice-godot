extends Area2D

signal info_area_entered(info_area)
signal info_area_exited(info_area)

export(String) var text = ""

func _on_InfoArea_body_entered(_body):
	SoundFx.play("ding")
	emit_signal("info_area_entered", self)

func _on_InfoArea_body_exited(_body):
	emit_signal("info_area_exited", self)

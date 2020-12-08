extends Area2D

signal info_area_entered(info_area)

export(String) var text = ""
var player_into_info_area = false
var can_emit = true

func _process(delta):
	if player_into_info_area and can_emit and not InfoAreaTexts.texts.has(text):
		InfoAreaTexts.texts.append(text)
		emit_signal("info_area_entered", self)
		can_emit = false

func _on_InfoArea_body_entered(body):
	player_into_info_area = true

func _on_InfoArea_body_exited(body):
	player_into_info_area = false

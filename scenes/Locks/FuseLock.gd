extends "res://scenes/Locks/Lock.gd"

onready var texture = $TextureRect

func open():
	SoundFx.play("opened")
	texture.visible = false
	sprite.frame = 1
	closed_area.queue_free()

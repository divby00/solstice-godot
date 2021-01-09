extends "res://scenes/Locks/Lock.gd"

onready var texture = $TextureRect

func open():
	SoundFx.play("opened")
	texture.visible = false
	sprite.frame = 1
	if closed_area != null:
		closed_area.queue_free()

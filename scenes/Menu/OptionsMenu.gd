extends Node2D

signal fullscreen_toggled(button_pressed)
signal sound_volume_changed(volume)
signal music_volume_changed(volume)

onready var sound_volume = $NinePatchRect/VBoxContainer/SoundSlider
onready var music_volume = $NinePatchRect/VBoxContainer/MusicSlider

func _on_FullscreenCheckBox_toggled(button_pressed):
	emit_signal("fullscreen_toggled", button_pressed)

func _on_SoundSlider_value_changed(value):
	emit_signal("sound_volume_changed", sound_volume.value)

func _on_MusicSlider_value_changed(value):
	emit_signal("music_volume_changed", music_volume.value)
